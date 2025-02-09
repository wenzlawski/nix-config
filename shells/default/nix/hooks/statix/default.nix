# This file is part of Nix++.
# Copyright (C) 2023 Leandro Emmanuel Reina Kiperman.
#
# Nix++ is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# Nix++ is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
{
  config,
  lib,
  pkgs,
  ...
}: let
  statix_toml = with pkgs;
    writeTextDir "statix.toml" ''
      disabled = [ 'redundant_pattern_bind', 'collapsible_let_in' ]
      nix_version = '${nix.version}'
    '';
in {
  pre-commit.hooks.statix = {
    enable = true;
    entry =
      lib.mkForce
      "${config.pre-commit.tools.statix}/bin/statix check -c ${statix_toml}";
  };
}
