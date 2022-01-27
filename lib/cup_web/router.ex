defmodule CupWeb.Router do
  use CupWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, {CupWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CupWeb.Auth    # auth.ex module plug - add :curent_member to conn.assigns
    # we want to find if member is logged to obtain access to :index & :show actions
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CupWeb do
    pipe_through :browser
                           # index route stores :index in conn
    get "/",               PageController, :index  # match URL & send to controller
    resources "/members",  MemberController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end


  # Other scopes may use custom stacks.
  # scope "/api", CupWeb do
  #   pipe_through :api
  # end
end
