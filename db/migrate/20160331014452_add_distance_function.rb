class AddDistanceFunction < ActiveRecord::Migration
  def up
    connection.execute(%q{
      CREATE OR REPLACE FUNCTION distance(lat1 FLOAT, lon1 FLOAT, lat2 FLOAT, lon2 FLOAT) RETURNS FLOAT AS $$
      DECLARE
         x float = 69.1 * (lat2 - lat1);
         y float = 69.1 * (lon2 - lon1) * cos(lat1 / 57.3);
      BEGIN
         RETURN sqrt(x * x + y * y);
      END
      $$ LANGUAGE plpgsql;
    })
  end

  def down
    connection.execute(%q{
      drop function distance
    })
  end
end
