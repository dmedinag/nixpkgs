{ lib
, requireFile
, lang
, majorVersion ? null
}:

let allVersions = with lib; flip map
  # N.B. Versions in this list should be ordered from newest to oldest.
  [
    {
      version = "12.1.1";
      lang = "en";
      language = "English";
      sha256 = "02mk8gmv8idnakva1nc7r7mx8ld02lk7jgsj1zbn962aps3bhixd";
    }
    {
      version = "12.1.0";
      lang = "en";
      language = "English";
      sha256 = "15m9l20jvkxh5w6mbp81ys7mx2lx5j8acw5gz0il89lklclgb8z7";
    }
    {
      version = "12.0.0";
      lang = "en";
      language = "English";
      sha256 = "b9fb71e1afcc1d72c200196ffa434512d208fa2920e207878433f504e58ae9d7";
    }
    {
      version = "11.3.0";
      lang = "en";
      language = "English";
      sha256 = "0fcfe208c1eac8448e7be3af0bdb84370b17bd9c5d066c013928c8ee95aed10e";
    }
    {
      version = "11.2.0";
      lang = "ja";
      language = "Japanese";
      sha256 = "916392edd32bed8622238df435dd8e86426bb043038a3336f30df10d819b49b1";
    }
  ]
  ({ version, lang, language, sha256 }: {
    inherit version lang;
    name = "mathematica-${version}" + optionalString (lang != "en") "-${lang}";
    src = requireFile rec {
      name = "Mathematica_${version}" + optionalString (lang != "en") "_${language}" + "_LINUX.sh";
      message = ''
        This nix expression requires that ${name} is
        already part of the store. Find the file on your Mathematica CD
        and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      '';
      inherit sha256;
    };
  });
minVersion =
  with lib;
  if majorVersion == null
  then elemAt (builtins.splitVersion (elemAt allVersions 0).version) 0
  else majorVersion;
maxVersion = toString (1 + builtins.fromJSON minVersion);
in
with lib;
findFirst (l: (l.lang == lang
               && l.version >= minVersion
               && l.version < maxVersion))
          (throw "Version ${minVersion} in language ${lang} not supported")
          allVersions
