defmodule CupWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use CupWeb, :controller
      use CupWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  ########################################
  # alias CupWeb.Router.Helpers  -       #
  # now we can get any Router thru       #
  # Routes.some_path                     #
  ########################################
  def controller do
    quote do
      use Phoenix.Controller, namespace: CupWeb

      import Plug.Conn
      import CupWeb.Auth, only: [authenticate_member: 2] # New import from auth
      alias Cup.Router.Helpers, as: Routes
    end
  end

  def view do          # contents of the view function - macro-expanded in to each view
                       # inject a chunk of code into each view
    quote do           # contents of the quote are executed for each view
      use Phoenix.View,
        root: "lib/cup_web/templates",
        namespace: CupWeb

        # Import convenience functions from controllers
        import Phoenix.Controller,
          only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]
          # Use all HTML functionality (forms, tags, etc)
          # Phoenix.HTML - generate links - work with forms - HTML safety
          #use Phoenix.HTML
          #import CupWeb.ErrorHelpers
          #alias CupWeb.Router.Helpers, as: Routes
        # Include shared imports and aliases for views
      unquote(view_helpers())

    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {CupWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import CupWeb.Auth, only: [authenticate_member: 2] # New import from auth
      #import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import CupWeb.ErrorHelpers
      alias CupWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
