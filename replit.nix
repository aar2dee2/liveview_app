{ pkgs }: {
	deps = [
		pkgs.elixir
    pkgs.postgresql_13
    pkgs.inotify-tools
    pkgs.nodejs-16_x
	];
}