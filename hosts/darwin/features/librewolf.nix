{
  config,
  pkgs,
  ...
}: {
  # https://mozilla.github.io/policy-templates/#extensionsettings
  system.defaults.CustomUserPreferences."org.mozilla.librewolf" = {
    EnterprisePoliciesEnabled = true;
    Homepage.StartPage = "none";
    Preferences = {
      accessibility.force_disabled.Value = -1;
    };
    SearchEngines = {
      Default = "DuckDuckGO";
      Remove = [
        "Google"
        "Bing"
        "Amazon.com"
        "eBay"
        "Twitter"
        "DuckDuckGo"
        "Wikipedia (en)"
      ];
      Add = [
        {
          Name = "Wikipedia";
          URLTemplate = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
          Method = "POST";
          Alias = "wi";
          Description = "Wikipedia";
          PostData = "q={searchTerms}";
        }
        {
          Name = "Google US";
          URLTemplate = "https://www.google.com/search?q={searchTerms}";
          Method = "GET";
          Alias = ";";
          Description = "Google US";
        }
        {
          Name = "DuckDuckGO";
          URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
          Method = "POST";
          Description = "DuckDuckGo";
          PostData = "q={searchTerms}";
        }
        {
          Name = "Goodreads";
          URLTemplate = "https://www.goodreads.com/search?q={searchTerms}";
          Method = "GET";
          Alias = "gr";
          Description = "Goodreads";
        }
        {
          Name = "Fmovies";
          URLTemplate = "https://fmovies24.to/filter?keyword={searchTerms}";
          Method = "GET";
          Alias = "fm";
          Description = "Fmovies";
        }
        {
          Name = "Libgen";
          URLTemplate = "https://libgen.rs/search.php?req={searchTerms}";
          Method = "POST";
          Alias = "lg";
          Description = "Lib gen";
          PostData = "q={searchTerms}";
        }
        {
          Name = "Zlib Articles";
          URLTemplate = "https://singlelogin.re/s/{searchTerms}?";
          Method = "GET";
          Alias = "zla";
          Description = "Z Library Articles";
        }
        {
          Name = "Zlib";
          URLTemplate = "https://singlelogin.re/s/{searchTerms}?";
          Method = "GET";
          Alias = "zl";
          Description = "Z Library";
        }
        {
          Name = "Plato";
          URLTemplate = "https://plato.stanford.edu/search/searcher.py?query={searchTerms}";
          Method = "GET";
          Alias = "pl";
          Description = "Plato Stanford";
        }
        {
          Name = "DuckDuckGo Lite";
          Description = "Minimal, ad-free version of DuckDuckGo";
          Alias = "d";
          Method = "POST";
          URLTemplate = "https://start.duckduckgo.com/lite/?q={searchTerms}";
          PostData = "q={searchTerms}";
        }
        {
          Name = "SearXNG - searx.be";
          Description = "A privacy-respecting, hackable metasearch engine";
          Alias = "";
          Method = "POST";
          URLTemplate = "https://searx.be/?q={searchTerms}";
          PostData = "q={searchTerms}";
        }
        {
          Name = "MetaGer";
          Description = "MetaGer - Privacy Protected Search Find";
          Alias = "";
          Method = "GET";
          URLTemplate = "https://metager.org/meta/meta.ger3?eingabe={searchTerms}";
        }
        {
          Name = "StartPage";
          Description = "The worlds most private search engine";
          Alias = "";
          Method = "GET";
          URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
        }
        {
          Name = "4get.ca (captcha)";
          Description = "A proxy search engine";
          Alias = "4get";
          Method = "GET";
          URLTemplate = "https://4get.ca/web?s={searchTerms}";
        }
      ];
    };
    DisableSystemAddonUpdate = false;
    FirefoxHome = {
      Search = true;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = false;
    };
    ExtensionUpdate = true;
    Extensions = {
      Install = [
        "https://addons.mozilla.org/firefox/downloads/latest/always-open-privately/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/behind_the_overlay/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/modern-for-wikipedia/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/onetab/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/speed-tweaks-webextension/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/surfingkeys_ff/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/temp-mail/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi"
        "https://addons.mozilla.org/firefox/downloads/latest/brotab/latest.xpi"
        "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi"
      ];
    };
  };
}
