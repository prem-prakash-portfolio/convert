defmodule CurrencyConverterWeb.Router do
  use CurrencyConverterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CurrencyConverterWeb do
    pipe_through :api

    resources "/quotations", QuotationController, only: [:index, :create]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :currency_converter, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      basePath: "/api",
      info: %{
        version: "1.0",
        title: "Currency Converter"
      }
    }
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:currency_converter, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CurrencyConverterWeb.Telemetry
    end
  end
end
