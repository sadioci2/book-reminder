describe Book do
  let(:book) do
    described_class.new(
      title: 'Test Book', author: 'Enthusiastic Writer', lender: 'Penn Libraries'
    )
  end

  it 'has a title' do
    expect(book.title).to eq 'Test Book'
  end
  it 'has an author' do
    expect(book.author).to eq 'Enthusiastic Writer'
  end
  it 'has a lender' do
    expect(book.lender).to eq 'Penn Libraries'
  end
end
