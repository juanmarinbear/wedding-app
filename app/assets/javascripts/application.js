// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.datepicker
//= require jquery.ui.slider
//= require jquery.ui.spinner
//= require jquery.ui.tooltip
//= require jquery.ui.effect
//= require jquery_ujs
//= require twitter/bootstrap
//= require flatuipro
//= require_tree .


$(document).ready(function(){
  set_select_styles();
  plus_one();
  minus_one();
  hide_default_tags();

  $('#help').tooltip({"title":"Escribe a jmbear@gmail.com",
                      "placement":'top'});


  $("input[type='file']").bootstrapFileInput();

  $('.photo-frame').hover(function(){
    $(this).find('.photo-info').animate({'bottom':0})
  },function(){
    $(this).find('.photo-info').animate({'bottom':'-50px'})
  })


  $("#main-photo").click(function(){
    $(this).parent().tooltip('destroy')
  });

  $('#add-photo').click(function(){
    var photos = $('.photos').length;
    //var clone = $('.clone-image').clone(true).removeClass('clone-image');

    var element = $("<div class='picture-container'> \
      <div class='field'> \
        <input title='Seleccionar Foto' name='uploader[images_attributes][][photo]' class='photos btn btn-info' type='file' /> \
      </div> \
      <input name='uploader[images_attributes][][tag_list]' class='tagsinput tagsinput-primary' value='juan, tabasco' /> \
  </div>");
    $('#photos-container').append(element);
    element.find('input.tagsinput').tagsInput();
    element.find("input[type='file']").bootstrapFileInput();
  });

  $('#cancel-present').click(function(){
    $('#present-button').show();
    $('#confirmation-message').hide();
    $('#mercadopago-container').hide()
  });

  $('#present-button').click(function(){
    //var index = $(".present-radio:checked").index('.present-radio');
    var index = $('.radio.checked').index('.radio')
    var value = $('.present-value:eq('+index+')').val();
    var pat = new RegExp('^[0-9]+$');
    
    if (value == '' || !pat.test(value) ) {
      $('.alerts').show();
      $("html, body").animate({ scrollTop: 0 }, "slow");
    }
    else{
      var jqxhr = $.post('/mercado_pago',{'value':value})
      .done(function(response) { 
        $('#present-button').hide();
        $('#value-present').html(value);
        $('#confirmation-message').show();
        $('#mercadopago-container').show().html(response.button)
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
          alert('fail');
       });
    }

  });

  $('#new_uploader').submit(function(event){

    var name = $('#uploader_name').val();
    var lastname = $('#uploader_lastname').val();
    var email = $('#uploader_email').val();
    var photo = $('#main-photo').val();

    var flag = true;

    if(name == ""){
      var control_group = $("input[name='uploader[name]']").parent();
      control_group.addClass('error');
      $(control_group).tooltip({"title":"Ingresa tu Nombre.",
                                "placement":'bottom',
                                "trigger":"manual"});
      $(control_group).tooltip('show');
      flag = false 
    }

    if(lastname == ""){
      var control_group = $("input[name='uploader[lastname]']").parent();
      control_group.addClass('error');
      $(control_group).tooltip({"title":"Ingresa tu Apellido(s).",
                                "placement":'bottom',
                                "trigger":"manual"});
      $(control_group).tooltip('show');
      flag = false
    }

    if(email == ""){
      var control_group = $("input[name='uploader[email]']").parent();
      control_group.addClass('error');
      $(control_group).tooltip({"title":"Email Invalido.",
                                "placement":'bottom',
                                "trigger":"manual"});
      $(control_group).tooltip('show');
      flag = false
    }

    if(photo == ""){
      var control_group = $('#main-photo').parent();
      control_group.addClass('error');
      $(control_group).tooltip({"title":"Selecciona al menos una imagen.",
                                "placement":'bottom',
                                "trigger":"manual"});
      $(control_group).tooltip('show');
      flag = false
    }

    return flag;

  });


  $(document).on('click', '#rsvp_submit', function(event){
    event.preventDefault();

    var action = $('#guest_form').attr('action');
    var guest_form = $('#guest_form').serialize();
    var jqxhr = $.post(action+".json",guest_form)
    .done(function(response) { 
      $('#rsvp_container').fadeOut(function(){
        $('#thanks').fadeIn();
        $("html, body").animate({ scrollTop: 0 }, "slow");
      });
    })
    .fail(function(jqXHR, textStatus, errorThrown) {
        var jsonValue = jQuery.parseJSON(jqXHR.responseText );
        var input;
        var attribute;
        $.each(jsonValue,function(key,value){
           input = 'input'
           keys = key.split('.')
           if (keys.length == 1){
              name = 'guest['+keys[0]+']';
              attribute = keys[0];
            }
           else{
              name = 'guest['+keys[0]+'_attributes]'+'['+keys[1]+']';
              attribute = keys[1];
            }

          if(attribute == 'dish')
            input = 'select';

          var control_group = $(input+"[name='"+name+"']").parent();

          control_group.addClass('error');
          $(control_group).tooltip({"title":value,
                                    "placement":'bottom',
                                    "trigger":"manual"});
          $(control_group).tooltip('show');
        });
     });
  });

  $(document).on('focus','#guest_form input, #new_uploader input',function(){
      $(this).parents('.control-group').removeClass('error')
      $(this).parent().tooltip('destroy')
  });

  $(document).on('click','#guest_form .dropdown-toggle',function(){
      $(this).parents('.control-group').tooltip('destroy')
  });

});

function plus_one() {
  $(document).on('click', '#plus_one_button', function(){
    $('#plus_one').html($('#plus_one_attributes').clone(true).show());
    $('#minus_one_button').show();
    $('#plus_one_button').hide();
  });
}

function minus_one() {
  $(document).on('click', '#minus_one_button', function(){
    $('#plus_one').html('');
    $('#minus_one_button').removeClass('visible').hide();
    $('#plus_one_button').removeClass('hidden').show();
  });
}

function set_select_styles(){
  $("select[class='huge']").selectpicker({style: 'btn-huge btn-primary', menuStyle: 'dropdown-inverse'});
  $("select[class='large']").selectpicker({style: 'btn-large btn-danger', menuStyle: 'dropdown-inverse'});
  $("select[class='info']").selectpicker({style: 'btn-info', menuStyle: 'dropdown-inverse'});
  $("select[class='small']").selectpicker({style: 'btn-small btn-warning', menuStyle: 'dropdown-inverse'});
}

function hide_default_tags(){
  $(document).on('focus',".tagsinput input",function(){
    var parent = $(this).parents('.tagsinput');
    var tagsinput = $(parent).prev('.tagsinput');
    if (tagsinput.val() == 'juan,dulce'){
      tagsinput.val('');
      $(parent).find('span').each(function(){
        $(this).remove();
      });
    }
  });
}
