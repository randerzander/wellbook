use wellbook;

set hive.execution.engine=tez;

select
   mnemonic,
   uom,
   average,
   median,
   stddev,
   variance,
   max,
   min
   range,
   histogram[0].x as x0,
   histogram[0].y as y0,
   histogram[1].x as x1,
   histogram[1].y as y1,
   histogram[2].x as x2,
   histogram[2].y as y2,
   histogram[3].x as x3,
   histogram[3].y as y3,
   histogram[4].x as x4,
   histogram[4].y as y4,
   histogram[5].x as x5,
   histogram[5].y as y5,
   histogram[6].x as x6,
   histogram[6].y as y6,
   histogram[7].x as x7,
   histogram[7].y as y7,
   histogram[8].x as x8,
   histogram[8].y as y8,
   histogram[9].x as x9,
   histogram[9].y as y9
from curve_statistics;
