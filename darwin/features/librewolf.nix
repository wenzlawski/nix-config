{
  config,
  pkgs,
  ...
}: {
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
        "https://addons.mozilla.org/firefox/downloads/file/3731774/always_open_privately-2.0.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/3923294/behind_the_overlay-0.2.1.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4307738/bitwarden_password_manager-2024.6.3.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/3970612/dark_mode_webextension-0.4.5.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4216095/istilldontcareaboutcookies-1.1.4.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4060590/modern_for_wikipedia-1.25.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4182157/old_reddit_redirect-1.8.1.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4175239/onetab-1.83.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4303450/privacy_badger17-2024.6.14.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/3642264/speed_tweaks_webextension-0.1.3.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4221189/surfingkeys_ff-1.16.1.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4298614/tab_session_manager-7.0.1.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/3990577/temp_mail-0.0.34.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4310845/tree_style_tab-4.0.20.xpi"
        "https://addons.mozilla.org/firefox/downloads/file/4263531/youtube_recommended_videos-1.6.7.xpi"
      ];
    };
  };
}
