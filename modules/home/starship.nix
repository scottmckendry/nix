{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = "$all $fill $cmd_duration\n$character";
      add_newline = true;
      line_break.disabled = true;
      fill.symbol = " ";
      golang.symbol = " ";

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      cmd_duration = {
        min_time = 10;
        show_milliseconds = true;
        format = "[$duration](bright-black)";
      };

      git_metrics = {
        disabled = false;
        format = "(([ $added ]($added_style))([ $deleted ]($deleted_style)))";
        only_nonzero_diffs = true;
        added_style = "green";
        deleted_style = "red";
      };
    };
  };
}
