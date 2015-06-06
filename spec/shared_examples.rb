require 'spec_helper'
shared_examples 'a video show page' do
  it 'sets @video variable' do
    expect(assigns(:video)).to eq(video)
  end

  it 'sets @reviews variable' do
    expect(assigns(:reviews)).to match_array(reviews)
  end

  it 'sets @review variable' do
    expect(assigns(:review)).to be_instance_of Review
    expect(assigns(:review)).to be_new_record
  end

  it 'sets @average_rating variable' do
    expect(assigns(:average_rating)).to be_instance_of Float
  end

  it 'sets @rating_chioces variable' do
    expect(assigns(:rating_chioces)).to be_instance_of Array
  end
end
