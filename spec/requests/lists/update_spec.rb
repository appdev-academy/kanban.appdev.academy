require 'rails_helper'

RSpec.describe 'PUT /lists/:id', type: :request do
  let(:board) { create(:board) }

  let(:params) { { list: list_params } }
  subject(:request) { put "/lists/#{list.id}", params: }

  context 'WITHOUT :position' do
    let!(:list) { create(:list, board:, position: 0) }
    let(:list_params) { { name: 'New List Name' } }

    it 'is expected to update List' do
      expect(list.reload.name).not_to eq('New List Name')

      request
      expect(response).to have_http_status(:ok)
      expect(list.reload.name).to eq('New List Name')
    end
  end

  context 'with :position' do
    let!(:list1) { create(:list, board:, position: 0) }
    let!(:list2) { create(:list, board:, position: 1) }
    let!(:list3) { create(:list, board:, position: 2) }
    let!(:list4) { create(:list, board:, position: 3) }
    let!(:list5) { create(:list, board:, position: 4) }

    let(:list_params) { { name: 'New List Name', position: } }
    let(:list) { list3 }

    context 'when moving to FIRST position' do
      let(:position) { 0 }

      it 'is expected to update current List and reposition all Lists in the Board' do
        expect(list.reload.name).not_to eq('New List Name')

        request

        expect(response).to have_http_status(:ok)
        expect(list.reload.name).to eq('New List Name')
        expect(list3.reload.position).to eq(0)
        expect(list1.reload.position).to eq(1)
        expect(list2.reload.position).to eq(2)
        expect(list4.reload.position).to eq(3)
        expect(list5.reload.position).to eq(4)
      end
    end

    context 'when moving to LAST position' do
      let(:position) { 4 }

      it 'is expected to update current List and reposition all Lists in the Board' do
        expect(list.reload.name).not_to eq('New List Name')

        request

        expect(response).to have_http_status(:ok)
        expect(list.reload.name).to eq('New List Name')
        expect(list1.reload.position).to eq(0)
        expect(list2.reload.position).to eq(1)
        expect(list4.reload.position).to eq(2)
        expect(list5.reload.position).to eq(3)
        expect(list3.reload.position).to eq(4)
      end
    end

    context 'when moving to MIDDLE position' do
      let(:list) { list2 }
      let(:position) { 3 }

      it 'is expected to update current List and reposition all Lists in the Board' do
        expect(list.reload.name).not_to eq('New List Name')

        request

        expect(response).to have_http_status(:ok)
        expect(list.reload.name).to eq('New List Name')
        expect(list1.reload.position).to eq(0)
        expect(list3.reload.position).to eq(1)
        expect(list4.reload.position).to eq(2)
        expect(list2.reload.position).to eq(3)
        expect(list5.reload.position).to eq(4)
      end
    end
  end
end
