defmodule Sobelow.CI.System do
  alias Sobelow.Utils
  use Sobelow.Finding

  def run(fun, filename) do
    severity = if String.ends_with?(filename, "_controller.ex"), do: false, else: :low
    {vars, params, {fun_name, [{_, line_no}]}} = parse_def(fun)

    Enum.each vars, fn var ->
      if Enum.member?(params, var) || var === "conn.params" do
        print_sys_finding(line_no, filename, fun_name, fun, var, severity || :high)
      else
        print_sys_finding(line_no, filename, fun_name, fun, var, severity || :medium)
      end
    end
  end

  def parse_def(fun) do
    Utils.get_fun_vars_and_meta(fun, 0, :cmd, [:System])
  end

  def print_sys_finding(line_no, filename, fun_name, fun, var, severity) do
    Utils.add_finding(line_no, filename, fun,
                      fun_name, var, severity,
                      "Command Injection in `System.cmd`", :cmd, [:System])
  end

  def get_details() do
    Sobelow.CI.details()
  end
end