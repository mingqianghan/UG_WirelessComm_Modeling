function [rmse,mae] = Model_evaluation(y, yhat)
% Model evaluation using RMSE and MAE
rmse = sqrt(mean((y - yhat).^2)); % RMSE
mae = norm(y - yhat,1)/length(y); % MAE
end