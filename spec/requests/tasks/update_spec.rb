require 'rails_helper'

RSpec.describe 'PUT /tasks/:id', type: :request do
  let(:board) { create(:board) }

  let(:params) { { task: task_params } }
  subject(:request) { put "/tasks/#{task.id}", params: }

  context 'WITHOUT :position and :list_id' do
    let(:list) { create(:list, board:, position: 0) }
    let!(:task) { create(:task, list:, position: 0) }

    let(:task_params) { { name: 'New Task Name' } }

    it 'is expected to update Task' do
      expect(task.reload.name).not_to eq('New Task Name')

      request
      expect(response).to have_http_status(:ok)
      expect(task.reload.name).to eq('New Task Name')
    end
  end

  context 'with :position' do
    let(:list1) { create(:list, board:, position: 0) }
    let!(:task11) { create(:task, list: list1, position: 0) }
    let!(:task12) { create(:task, list: list1, position: 1) }
    let!(:task13) { create(:task, list: list1, position: 2) }
    let!(:task14) { create(:task, list: list1, position: 3) }
    let!(:task15) { create(:task, list: list1, position: 4) }

    context 'WITHOUT :list_id' do
      let(:task_params) { { name: 'New Task Name', position: } }
      let(:task) { task13 }

      context 'when moving to FIRST position' do
        let(:position) { 0 }

        it 'is expected to update Task and reposition all Tasks in the List' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request
          task.reload

          expect(response).to have_http_status(:ok)
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          expect(task13.reload.position).to eq(0)
          expect(task11.reload.position).to eq(1)
          expect(task12.reload.position).to eq(2)
          expect(task14.reload.position).to eq(3)
          expect(task15.reload.position).to eq(4)
        end
      end

      context 'when moving to LAST position' do
        let(:position) { 4 }

        it 'is expected to update Task and reposition all Tasks in the List' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request
          task.reload

          expect(response).to have_http_status(:ok)
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          expect(task11.reload.position).to eq(0)
          expect(task12.reload.position).to eq(1)
          expect(task14.reload.position).to eq(2)
          expect(task15.reload.position).to eq(3)
          expect(task13.reload.position).to eq(4)
        end
      end

      context 'when moving to MIDDLE position' do
        let(:task) { task12 }
        let(:position) { 3 }

        it 'is expected to update Task and reposition all Tasks in the List' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request
          task.reload

          expect(response).to have_http_status(:ok)
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          expect(task11.reload.position).to eq(0)
          expect(task13.reload.position).to eq(1)
          expect(task14.reload.position).to eq(2)
          expect(task12.reload.position).to eq(3)
          expect(task15.reload.position).to eq(4)
        end
      end
    end

    context 'with :list_id' do
      let(:list2) { create(:list, board:, position: 0) }
      let!(:task21) { create(:task, list: list2, position: 0) }
      let!(:task22) { create(:task, list: list2, position: 1) }
      let!(:task23) { create(:task, list: list2, position: 2) }
      let!(:task24) { create(:task, list: list2, position: 3) }
      let!(:task25) { create(:task, list: list2, position: 4) }

      let(:task_params) { { name: 'New Task Name', position:, list_id: list2.id } }
      let(:task) { task13 }

      context 'when moving to FIRST position' do
        let(:position) { 0 }

        it 'is expected to move Task to new List and reposition Tasks in both Lists' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request

          expect(response).to have_http_status(:ok)

          task.reload
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list2.id)

          expect(task13.reload.position).to eq(0)
          expect(task21.reload.position).to eq(1)
          expect(task22.reload.position).to eq(2)
          expect(task23.reload.position).to eq(3)
          expect(task24.reload.position).to eq(4)
          expect(task25.reload.position).to eq(5)

          expect(task11.reload.position).to eq(0)
          expect(task12.reload.position).to eq(1)
          expect(task14.reload.position).to eq(2)
          expect(task15.reload.position).to eq(3)
        end
      end

      context 'when moving to LAST position' do
        let(:position) { 5 }

        it 'is expected to move Task to new List and reposition Tasks in both Lists' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request

          expect(response).to have_http_status(:ok)

          task.reload
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list2.id)

          expect(task21.reload.position).to eq(0)
          expect(task22.reload.position).to eq(1)
          expect(task23.reload.position).to eq(2)
          expect(task24.reload.position).to eq(3)
          expect(task25.reload.position).to eq(4)
          expect(task13.reload.position).to eq(5)

          expect(task11.reload.position).to eq(0)
          expect(task12.reload.position).to eq(1)
          expect(task14.reload.position).to eq(2)
          expect(task15.reload.position).to eq(3)
        end
      end

      context 'when moving to MIDDLE position' do
        let(:position) { 3 }

        it 'is expected to move Task to new List and reposition Tasks in both Lists' do
          task.reload
          expect(task.name).not_to eq('New Task Name')
          expect(task.list_id).to eq(list1.id)

          request

          expect(response).to have_http_status(:ok)

          task.reload
          expect(task.name).to eq('New Task Name')
          expect(task.list_id).to eq(list2.id)

          expect(task21.reload.position).to eq(0)
          expect(task22.reload.position).to eq(1)
          expect(task23.reload.position).to eq(2)
          expect(task13.reload.position).to eq(3)
          expect(task24.reload.position).to eq(4)
          expect(task25.reload.position).to eq(5)

          expect(task11.reload.position).to eq(0)
          expect(task12.reload.position).to eq(1)
          expect(task14.reload.position).to eq(2)
          expect(task15.reload.position).to eq(3)
        end
      end
    end
  end
end
