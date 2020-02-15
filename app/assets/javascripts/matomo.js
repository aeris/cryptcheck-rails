var _paq = window._paq || [];

document.addEventListener('DOMContentLoaded', function() {
    const { matomoUrl: url, matomoSite: site } = document.documentElement.dataset
    console.log(url, site);
    if ( url == undefined || site == undefined ) return;

    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);
    _paq.push(['setTrackerUrl', url]);
    _paq.push(['setSiteId', site]);

    const d = document,
        g = d.createElement('script'),
        s = d.getElementsByTagName('script')[0]

    g.type = 'text/javascript'
    g.async = true
    g.defer = true
    g.src = url
    s.parentNode.insertBefore(g, s)
})
