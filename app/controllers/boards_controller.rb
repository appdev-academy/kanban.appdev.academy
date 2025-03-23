class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]

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

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /boards/:id (board)
  # @route PUT /boards/:id (board)
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /boards/:id (board)
  def destroy
    @board.destroy!

    respond_to do |format|
      format.html { redirect_to boards_path, status: :see_other }
      format.json { head :no_content }
    end
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
