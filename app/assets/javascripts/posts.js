$(function(){
  // jquery loaded
  $("#post-comment").on("click", function(){
    $("#comment_comment").focus();
  });

  $(".post-like").on("click", function(){
    var post_id = $(this).data("id");

    $.ajax({
      url: "/post/like/"+post_id,
      method: "GET"
    });
  });

  // when user scrolls to bottom of feed, then load more posts and append to feed
  $('document').on('scroll', function() {
    if($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
        alert('end reached');
        console.log('end reached');
    }
  });
});
