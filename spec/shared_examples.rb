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
end
