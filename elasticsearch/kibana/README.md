# Kibana Dashboard

`PS` Assuming you already ran `docker-compose up` following [these instructions](../../README.md).

Accessing in your prefered browser [http://localhost:5601/app/kibana](http://localhost:5601/app/kibana)

## Setup (Users index)

1. Open the `Management` option on the menu

<img width="582" alt="Screen Shot 2020-05-17 at 17 15 09" src="https://user-images.githubusercontent.com/3486950/82159108-52b48280-9862-11ea-805c-c68433849dfe.png">

2. Access `Kibana > Index Patterns`

<img width="719" alt="Screen Shot 2020-05-17 at 17 15 19" src="https://user-images.githubusercontent.com/3486950/82159107-521bec00-9862-11ea-9bf2-3aa02393d7a6.png">

3. Click on the `Create index pattern` button

<img width="450" alt="Screen Shot 2020-05-17 at 17 15 34" src="https://user-images.githubusercontent.com/3486950/82159106-521bec00-9862-11ea-8012-09a3f7e73f1d.png">

4. Type on the `index pattern` input field, the same value you choose for `BOILERPLATE_USERS_ELASTIC_INDEX` variable (e.g `postgresql.public.users`)

<img width="478" alt="Screen Shot 2020-05-17 at 17 15 41" src="https://user-images.githubusercontent.com/3486950/82159105-51835580-9862-11ea-8f40-5507f7d87c44.png">

5. Click on the `Create index pattern` button

<img width="1296" alt="Screen Shot 2020-05-17 at 17 15 54" src="https://user-images.githubusercontent.com/3486950/82159103-51835580-9862-11ea-8ccd-d632478878e9.png">

6. You should be able to see something linke

<img width="1268" alt="Screen Shot 2020-05-17 at 17 16 05" src="https://user-images.githubusercontent.com/3486950/82159102-50eabf00-9862-11ea-8e3f-7605dc927bff.png">

7. Go to the `discover` by clicking on the menu

<img width="2048" alt="Screen Shot 2020-05-17 at 17 16 23" src="https://user-images.githubusercontent.com/3486950/82159100-4d573800-9862-11ea-90c3-c1cd74d776f2.png">
