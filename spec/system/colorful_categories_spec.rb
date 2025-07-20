# frozen_string_literal: true

RSpec.describe "Colorful Categories", system: true do
  fab!(:user)
  fab!(:category) { Fabricate(:category, color: "DABBED") }
  fab!(:topic) { Fabricate(:topic, category: category) }
  fab!(:posts) { Fabricate.times(3, :post, topic: topic) }

  before do
    upload_theme_component
    sign_in(user)
  end

  context "when visiting a category page" do
    it "changes the header background color" do
      visit "/c/#{category.id}"

      background_color =
        page.evaluate_script(
          "window.getComputedStyle(document.querySelector('.d-header')).backgroundColor",
        )

      expect(background_color).to eq("rgb(218, 187, 237)") # RGB for #DABBED
    end
  end

  context "when visiting a topic page" do
    before { visit "/t/#{topic.id}" }

    it "changes the header background color" do
      background_color =
        page.evaluate_script(
          "window.getComputedStyle(document.querySelector('.d-header')).backgroundColor",
        )

      expect(background_color).to eq("rgb(218, 187, 237)")
    end

    it "changes the reply button color" do
      button_color =
        page.evaluate_script(
          "window.getComputedStyle(document.querySelector('.btn-primary.create')).backgroundColor",
        )

      expect(button_color).to eq("rgb(218, 187, 237)")
    end

    it "changes the timeline handle color" do
      timeline_color =
        page.evaluate_script(
          "window.getComputedStyle(document.querySelector('.topic-timeline .timeline-handle')).backgroundColor",
        )

      expect(timeline_color).to eq("rgb(218, 187, 237)")
    end

    it "changes the composer color" do
      find("#topic-footer-buttons .create").click

      grippie_color =
        page.evaluate_script(
          "window.getComputedStyle(document.querySelector('.grippie')).backgroundColor",
        )

      expect(grippie_color).to eq("rgb(218, 187, 237)")
    end
  end
end
