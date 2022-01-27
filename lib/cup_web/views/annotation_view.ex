defmodule CupWeb.AnnotationView do
  use CupWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id:   annotation.id,
      body: annotation.body,
      at:   annotation.at,
      member: render_one(annotation.member, CupWeb.MemberView, "member.json")
    }
  end
end
