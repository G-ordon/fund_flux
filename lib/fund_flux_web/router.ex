defmodule FundFluxWeb.Router do
  use FundFluxWeb, :router

  import FundFluxWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FundFluxWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FundFluxWeb do
    pipe_through :browser

    get "/", PageController, :home

    # Routes for money transfers
    live "/money_transfers", MoneyTransferLive.Index, :index
    live "/money_transfers/new", MoneyTransferLive.New, :new
    live "/money_transfers/:id/edit", MoneyTransferLive.Edit, :edit
    live "/money_transfers/:id", MoneyTransferLive.Show, :show

    # Dedicate this LiveView for receiving money
    live "/money_transfer/receive", MoneyTransferLive.ReceiveMoney

    live "/user_balances", UserBalanceLive.Index, :index
    live "/user_balances/new", UserBalanceLive.Index, :new
    live "/user_balances/:id/edit", UserBalanceLive.Index, :edit
    live "/user_balances/:id", UserBalanceLive.Show, :show
    live "/user_balances/:id/show/edit", UserBalanceLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FundFluxWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:fund_flux, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FundFluxWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FundFluxWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{FundFluxWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", FundFluxWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{FundFluxWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", FundFluxWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{FundFluxWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
