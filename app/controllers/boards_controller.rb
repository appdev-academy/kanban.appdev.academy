class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]

  # @route GET / (root)
  # @route GET /boards (boards)
  def index
    @boards = Board.ordered
  end

  # @route GET /boards/:id (board)
  def show
  end

  # @route GET /boards/new (new_board)
  def new
    @board = Board.new
  end

  # @route GET /boards/:id/edit (edit_board)
  def edit
  end

  # @route POST /boards (boards)
  def create
    @board = Board.new(board_params)

    if @board.save
        redirect_to @board
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /boards/:id (board)
  # @route PUT /boards/:id (board)
  def update
    if @board.update(board_params)
      redirect_to boards_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /boards/:id (board)
  def destroy
    @board.destroy!

    redirect_to boards_path, status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_board
    @board = Board.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def board_params
    params.expect(board: [:name])
  end
end
