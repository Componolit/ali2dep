--
--  @summary ALI to make dependency generator
--  @author  Alexander Senier
--  @date    2019-02-01
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of ali2dep, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package ALI2Dep
is
   procedure Handle_ALI (Path : String);

   Invalid_ALI_File : exception;
end ALI2Dep;
