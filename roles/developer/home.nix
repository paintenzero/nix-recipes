{ inputs, username, packages, ... }: {
  home-manager = {
    extraSpecialArgs = {
      inherit packages;
    };
    users.${username} = { pkgs, ... }: {
      imports = [
        ../../modules/home/all.nix
      ];
    	home.packages = with pkgs; [ nixfmt ];
			
      vscode.enable = true;
      cursor.enable = true;
      
      programs.git = {
        enable = true;
        userName = "Sergei Biriukov";
        userEmail = "sergeyb26@gmail.com";
        extraConfig.init.defaultBranch = "main";
      };

      programs.helix = {
        enable = true;
        settings = {
          theme = "catppuccin_macchiato";
          editor.cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
        };
        languages.language = [{
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }];
        defaultEditor = true;
      };

    };
  };
}
