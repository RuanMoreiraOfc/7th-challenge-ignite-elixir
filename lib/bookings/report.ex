defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent

  @file_name "report.csv"

  def generate(from_date, to_date) do
    content =
      Agent.get_all()
      |> Map.values()
      |> Enum.map(&Map.from_struct/1)
      |> filter_between(from_date, to_date)
      |> Enum.map(&date_to_string/1)
      |> Enum.map(&parse_line/1)
      |> Enum.join("\n")

    File.write!(@file_name, content)

    {:ok, "Report generated successfully"}
  end

  defp filter_between(map, from_date, to_date) do
    Enum.filter(map, fn %{complete_date: date} ->
      NaiveDateTime.compare(from_date, date) !== :gt and
        NaiveDateTime.compare(date, to_date) !== :gt
    end)
  end

  defp date_to_string(map) do
    Map.update!(map, :complete_date, &NaiveDateTime.to_string/1)
  end

  defp parse_line(%{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}"
  end
end
