data {
  int<lower=1> I;               // # questions
  int<lower=1> J;               // # persons
  int<lower=1> N;               // # observations
  int<lower=1, upper=I> ii[N];  // question for n
  int<lower=1, upper=J> jj[N];  // person for n
  int<lower=0, upper=1> y[N];   // correctness for n
  int<lower=1> K;               // # person covariates
  matrix[J,K] W;                // person covariate matrix
}
parameters {
  vector[I-1] beta_free;
  vector[J] theta_resid;
  real<lower=0> sigma;
  vector[K] lambda;
}
transformed parameters {
  vector[I] beta;
  vector[J] theta;
  beta = append_row(beta_free, rep_vector(-1*sum(beta_free), 1));
  theta = W*lambda + theta_resid * sigma;
}
model {
  beta_free ~ normal(0, 5);
  theta_resid ~ normal(0, 1);
  sigma ~ exponential(.1);
  y ~ bernoulli_logit(theta[jj] - beta[ii]);
}
