defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.{Agent, Booking}

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    {:ok, booking} =
      Booking.build(
        complete_date,
        local_origin,
        local_destination,
        user_id
      )

    Agent.save(booking)
  end
end
