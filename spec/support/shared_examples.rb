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

shared_examples 'require user signed in' do
  before { clear_current_user }

  it 'redirects to root path' do
    action
    expect(response).to redirect_to root_path
  end

  it 'sets flash[:error] message' do
    action
    expect(flash[:error]).to be_present
  end
end
