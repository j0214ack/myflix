require 'spec_helper'

feature 'My Queue' do
  scenario 'user add a video to queue' do
    user = Fabricate(:user)
    category = Fabricate(:category)
    videos = Fabricate.times(3, :video, category: category)

    login_user_in_capybara(user)

    add_video_to_queue(videos[0])
    click_my_queue_link

    expect_video_title_in_queue_list(videos[0])
    expect_video_title_links_back_to_video(videos[0])
    expect_video_page_has_no_add_my_queue_link

    add_video_to_queue(videos[1])
    add_video_to_queue(videos[2])

    click_my_queue_link

    fill_in_video_position(videos[0], 5)
    fill_in_video_position(videos[1], 3)
    fill_in_video_position(videos[2], 4)

    update_my_queue

    expect_video_at_position(videos[1],1)
    expect_video_at_position(videos[2],2)
    expect_video_at_position(videos[0],3)
  end

  def add_video_to_queue(video)
    visit home_path
    find_link_with_href("/videos/#{video.id}").click
    click_link '+ My Queue'
  end

  def click_my_queue_link
    click_link 'My Queue'
  end

  def expect_video_title_in_queue_list(video)
    expect(find("tbody")).to have_content video.title
  end

  def expect_video_title_links_back_to_video(video)
    click_link video.title
    expect(page.current_path).to eq video_path(video)
  end

  def expect_video_page_has_no_add_my_queue_link
    expect(page).not_to have_content '+ My Queue'
  end

  def fill_in_video_position(video, position)
    fill_in "video_#{video.id}", with: position
  end

  def update_my_queue
    click_on 'Update Instant Queue'
  end

  def expect_video_at_position(video, position)
    expect(find("tbody tr:eq(#{position})")).to have_content video.title
  end
end
