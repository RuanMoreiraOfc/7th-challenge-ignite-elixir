defmodule FlightexTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.{Agent}

  setup do
    Flightex.start_agents()

    :ok
  end

  describe "create_or_update_booking/1" do
    test "create booking" do
      params = %{
        complete_date: ~N[2021-03-22 19:29:25.607218],
        local_origin: "Vitória",
        local_destination: "Salvador",
        user_id: "user_id1"
      }

      {:ok, uuid} = Flightex.create_or_update_booking(params)
      {:ok, booking} = Agent.get(uuid)

      assert params.user_id === booking.user_id
    end
  end

  describe "generate_report/2" do
    test "create `report.csv` in the date range" do
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

      content = "user_id2,São Paulo,Rio de Janeiro,2021-03-14 12:12:25.60721"

      Flightex.create_or_update_booking(params1)
      Flightex.create_or_update_booking(params2)
      Flightex.generate_report(~N[2021-01-22 12:00:00], ~N[2021-03-18 00:00:00])
      {:ok, file} = File.read("report.csv")

      assert file =~ content
    end
  end
end
