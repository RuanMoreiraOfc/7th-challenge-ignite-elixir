# Este teste é opcional, mas vale a pena tentar e se desafiar 😉

defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params1 = %{
        complete_date: ~N[2021-03-22 19:29:25.607218],
        local_origin: "Vitória",
        local_destination: "Salvador",
        user_id: "user_id1",
        id: UUID.uuid4()
      }

      params2 = %{
        complete_date: ~N[2021-03-14 12:12:25.607218],
        local_origin: "São Paulo",
        local_destination: "Rio de Janeiro",
        user_id: "user_id2",
        id: UUID.uuid4()
      }

      params3 = %{
        complete_date: ~N[2021-04-18 08:45:25.607218],
        local_origin: "São Paulo",
        local_destination: "Londres",
        user_id: "user_id3",
        id: UUID.uuid4()
      }

      content = "user_id2,São Paulo,Rio de Janeiro,2021-03-14 12:12:25.60721"

      Flightex.create_or_update_booking(params1)
      Flightex.create_or_update_booking(params2)
      Flightex.create_or_update_booking(params3)
      Report.generate(~N[2021-01-22 12:00:00], ~N[2021-03-18 00:00:00])
      {:ok, file} = File.read("report.csv")

      assert file =~ content
    end
  end
end
