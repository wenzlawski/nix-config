api.unmap('ob');    // I don't need the omnibar search feature,
api.unmap('od');    // and I want to use the `o` key ...
api.unmap('og');
api.unmap('oh');
api.unmap('oi');
api.unmap('om');
api.unmap('on');
api.unmap('ow');
api.unmap('ox');
api.unmap('oy');

api.map('o', 'f');      // Typical link jumping
api.map('ao', 'af');    // Open link in a new, focused tab
api.map('go', 'gf');    // Open link in a new, non-focused tab
api.map('co', 'cf');    // Open multiple links... I don't use this

settings.aceKeybindings = "vim";

api.Hints.style("             \
 text-align: center;          \
 vertical-align: middle;      \
 border: 2px solid #303030;   \
 border-radius: 25%;          \
 padding: .2%;                 \
 background: #FFBC2E;         \
 color: #000000;              \
 font-size:10pt;              \
 font-family: Input Sans Condensed, Charcoal, sans-serif;",
  "hint"
);

settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 11pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 14pt;
}`;
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
