class ShipmentsController < ApplicationController
  def show
    if shipment.success?
      render json: shipment.value, status: :ok
    else
      render json: shipment.error, status: :not_found
    end
  end

private

  def shipment_params
    params.permit(:strategy, :origin_port, :destination_port).to_h
  end

  def shipment
    ShyppleService.call(
      strategy: shipment_params['strategy'],
      origin_port: shipment_params['origin_port'],
      destination_port: shipment_params['destination_port']
    )
  end
end
