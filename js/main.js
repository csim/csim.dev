var ready = function()
{
    var loc = window.location.href.toLowerCase();
    var active = null;

    if (loc.indexOf('/about') > -1)
    {
        active = $('#about');
    } else if (loc.indexOf('/topics') > -1)
    {
        active = $('#topics').addClass('active');
    } else if (loc.indexOf('/archive') > -1)
    {
        active = $('#archive').addClass('active');
    }

    if (active !== null) {
        active.addClass('active')
    }
};

$(document).ready(ready);