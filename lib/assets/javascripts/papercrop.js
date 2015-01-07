(function ($) {
  window.jcrop_api = null;

  window.init_papercrop = function() {
    $("div[id$=_crop_wrapper]").each(function() {

      var attachment = $(this).attr("id").replace("_crop_wrapper", "");
      var preview    = !!$("#" + attachment + "_crop_preview").length;
      var aspect     = $("input#" + attachment + "_aspect").val();
      var width      = $(this).width();

      update_crop = function(coords) {
        var preview_width, rx, ry;

        if (preview) {
          preview_width = $("#" + attachment + "_crop_preview_wrapper").width();

          rx = preview_width / coords.w;
          ry = preview_width / coords.h;

          $("img#" + attachment + "_crop_preview").css({
            width      : Math.round(rx * $("input[id$='_" + attachment + "_original_w']").val()) + "px",
            height     : Math.round((ry * $("input[id$='_" + attachment + "_original_h']").val()) / aspect) + "px",
            marginLeft : "-" + Math.round(rx * coords.x) + "px",
            marginTop  : "-" + Math.round((ry * coords.y) / aspect) + "px"
          });
        }

        $("#" + attachment + "_crop_x").val(Math.round(coords.x));
        $("#" + attachment + "_crop_y").val(Math.round(coords.y));
        $("#" + attachment + "_crop_w").val(Math.round(coords.w));
        $("#" + attachment + "_crop_h").val(Math.round(coords.h));
      };

      var crop_x = parseFloat($("#" + attachment + "_crop_x").val());
      var crop_y = parseFloat($("#" + attachment + "_crop_y").val());
      var crop_w = parseFloat($("#" + attachment + "_crop_w").val());
      var crop_h = parseFloat($("#" + attachment + "_crop_h").val());

      $(this).find("img").Jcrop({
        onChange    : update_crop,
        onSelect    : update_crop,
        setSelect   : [crop_x, crop_y, crop_x + crop_w, crop_y + crop_h],
        aspectRatio : aspect,
        boxWidth    : $("input[id$='_" + attachment + "_box_w']").val()
      }, function() {
        jcrop_api = this;
      });
    });
  };

  $(document).ready(function() {
    init_papercrop();
  });

}(jQuery));
