$(window).load(function () {
    $('#load-more').hide();
    $('.spinner').hide()
    var token = document.getElementById('HiddenField1').value;
    //alert("TOKEN"+token);
    if (token !== '') {
        var group_id = "1448106738825094";
        var request_url = "https://graph.facebook.com/v2.12/" + group_id + "/feed?limit=20&access_token=" + token +"&fields=link,created_time,story,from{name,picture,link},id,permalink_url,message,comments.summary(1).order(reverse_chronological).limit(4){message,from{name,picture,link}},likes{total_count},picture,attachments";
        //load inital data with two feeds
        $.ajax({
            dataType: 'jsonp',
            type: 'GET',
            url: request_url,
            success: function (result) {
                if (result['data'].length > 0) {
                    $('.initital-loader').remove();
                    var renderHTML = renderMoreContent(result['data']);
                    $('.content .load-more-wrapper').before(renderHTML)
                    //set load more for next data
                    $('#loadmorehidden').val(result['paging']['next']);
                    $('#load-more').show();
                }
                else {
                    $('#load-more').remove()
                }
            }
        });
        
    }
});

function renderMoreComments(data, element_id) {
    feedHtml = "";
    console.log(data);
    data.forEach(function (comment) {
        feedHtml = feedHtml + "<div class='comment-wrapper'>";
        feedHtml = feedHtml + "<img class='comment-profile-thumb' src='" + comment["from"]["picture"]["data"]["url"] + "' />";
        feedHtml = feedHtml + "<div class='comment'>";
        feedHtml = feedHtml + "<a class='profile-name-comments' href='" + comment["from"]["link"] + "' >" + comment["from"]["name"] + "</a>";
        feedHtml = feedHtml + "<span class='comment-body'  >" + comment["message"] + "</span>";
        feedHtml = feedHtml + "</div>";
        feedHtml = feedHtml + "</div>";
    }
    )
    $("div#" + element_id + " .comment-wrapper").first().before(feedHtml);
}

function viewMoreComments(element) {
    var loadMoreUrl = $('#' + element.id + " a").attr('redirecturl');
    if (loadMoreUrl !== '') {
        console.log(loadMoreUrl);
        loadMoreUrl = loadMoreUrl.replace(/u00257B/g, '{').replace(/u00257D/g, '}')
        loadMoreUrl = loadMoreUrl.replace(/u002528/g, '(').replace(/u002529/g, ')')

        $.ajax({
            dataType: 'jsonp',
            type: 'GET',
            url: loadMoreUrl + "&fields=message,from{name,picture,link}",
            success: function (result) {
                if (result['data'].length > 0) {
                    renderMoreComments(result['data'], element.id);
                    //set load more for next data
                    if (result['paging']['next'])
                        $('#' + element.id + ".view-all").attr('redirecturl', result['paging']['next']);
                    else
                        $('#' + element.id + ".view-all").remove()
                }
            }
        });
    }
}
function renderMoreContent(data) {
    var monthNames = [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ];
    var feedHtml = '';
    data.forEach(function (element) {
        var dateTimeStamp = new Date(element["created_time"]);
        var created_date = monthNames[dateTimeStamp.getMonth()] + ' ' + dateTimeStamp.getDate() + ', ' + dateTimeStamp.getFullYear() + ' at ' + dateTimeStamp.toLocaleString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true });
        feedHtml = feedHtml + "<div class= 'feed'>";
        feedHtml = feedHtml + "<div class = 'feed-card'>";
        feedHtml = feedHtml + "<div>";
        feedHtml = feedHtml + "<img class='profile-thumb' src='" + element["from"]["picture"]["data"]["url"] + "' /><div>";
        feedHtml = feedHtml + "<a class='profile-name' href='" + element["from"]["link"] + "' >" + element["from"]["name"] + "</a>";
        feedHtml = feedHtml + "<span class = 'created-time'>" + created_date + "</span>";
        feedHtml = feedHtml + "</div></div><div class='feed-msg-wrapper'>";
        if (element["message"] != null) {
            feedHtml = feedHtml + "<p class='feed-msg'>" + element["message"] + "</p>";
        }
        else if (element["story"] != null) {
            feedHtml = feedHtml + "<p class='feed-story'>" + element["story"] + "</p>";
        }
        if (element["link"] != null) {
            feedHtml = feedHtml + "<a class='feed-story' href='" + element["link"] + "'>Follow the link here</a>";
        }
        if (element["picture"] != null) {
            feedHtml = feedHtml + "<div class='post-image'><img src='" + element["picture"] + "'></div>";
        }
        feedHtml = feedHtml + "</div>";

        feedHtml = feedHtml + "<div class='like-cmnt-wrapper'><i class='fb-icon far fa-thumbs-up'></i><span class='icon-count'>";

        if (element["likes"] != null) { feedHtml = feedHtml + element["likes"]["data"].length } else { feedHtml = feedHtml + "0"; }
        feedHtml = feedHtml + "</span><i class='fb-icon far fa-comment'></i><span class='icon-count'>";

        if (element["comments"]["data"].length > 0) { feedHtml = feedHtml + element["comments"]["summary"]["total_count"] } else { feedHtml = feedHtml + "0"; }

        feedHtml = feedHtml + "</span></div>";
        feedHtml = feedHtml + "</div>";
        //comments wrapper start

        if ( element["comments"]["data"].length > 0) {
            feedHtml = feedHtml + "<div class='comments-wrapper' id='" + element["id"] + "'>";
            if (element["comments"]["summary"]["total_count"] > 4) {
                var viewMoreUrl = element["comments"]["paging"]["next"];
                var appendId = element["id"];
                feedHtml = feedHtml + "<a redirectUrl='" + viewMoreUrl + "' onClick='viewMoreComments(this); return false;' id='" + appendId + "' class='view-all'>View more comments</a>";

            }
            element["comments"]["data"].forEach(function (comment) {
                feedHtml = feedHtml + "<div class='comment-wrapper'>";
                feedHtml = feedHtml + "<img class='comment-profile-thumb' src='" + comment["from"]["picture"]["data"]["url"] + "' />";
                feedHtml = feedHtml + "<div class='comment'>";
                feedHtml = feedHtml + "<a class='profile-name-comments' href='" + comment["from"]["link"] + "' >" + comment["from"]["name"] + "</a>";
                feedHtml = feedHtml + "<span class='comment-body'  >" + comment["message"] + "</span>";
                feedHtml = feedHtml + "</div>";
                feedHtml = feedHtml + "</div>";
            });
            feedHtml = feedHtml + "</div>";
        }

        feedHtml = feedHtml + "</div>";
        //comments wrapper end
    });
    return feedHtml;
    //console.log("html to append", feedHtml);
    
}

$('#load-more').click(function () {
    $('.spinner').show();
    $('#load-more').hide();
    var loadMoreUrl = document.getElementById('loadmorehidden').value;
    loadMoreUrl = loadMoreUrl.replace(/u00257B/g, '{').replace(/u00257D/g, '}')
    loadMoreUrl = loadMoreUrl.replace(/u002528/g, '(').replace(/u002529/g, ')')
    console.log(loadMoreUrl)
    $.ajax({
        dataType: 'jsonp',
        type: 'GET',
        url: loadMoreUrl,
        success: function (result) {
            $('.spinner').hide();
            $('#load-more').show();
            if (result['data'].length > 0) {
                var feedHtml = renderMoreContent(result['data']);
                $('.feed:last').after(feedHtml);
                //set load more for next data
                $('#loadmorehidden').val(result['paging']['next']);
            }
            else {
                //console.log("no data after this");
                $('#load-more').remove()
            }
        }
    });
})
