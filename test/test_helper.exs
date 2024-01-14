# start ex_machina
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
