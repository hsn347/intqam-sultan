local equipDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "material_workshop"
	;(nil)[2] = true
	equipDesRead:defineValue("factory", nil)
	equipDesRead = nil
	;(nil)[1] = "equipment_config"
	equipDesRead:defineValue("base", nil)
	equipDesRead = nil
	;(nil)[1] = "suit_attribute_tendency"
	equipDesRead:defineValue("tendency", nil)
	_ENV = nil
	;(nil)[1] = "property_prompt"
	;(nil)[2] = true
	equipDesRead:defineValue("property_prompt", nil)
	equipDesRead:defineValue("attrColor", function()
		_ENV = nil
		;(nil)[0] = cc.c3b(230, 230, 230)
		;(nil)[1] = cc.c3b(0, 255, 0)
		;(nil)[2] = cc.c3b(0, 185, 255)
		;(nil)[3] = cc.c3b(255, 0, 255)
		;(nil)[4] = cc.c3b(255, 190, 60)
		;(nil)[888] = cc.c3b(255, 0, 0)
		;(nil)[999] = cc.c3b(255, 0, 0)
		return nil
	end)
	equipDesRead:defineValue("mQualityName", function()
		_UPVALUE0_ = nil
		;(nil)[0] = "common_text_1386"
		;(nil)[1] = "common_text_1387"
		;(nil)[2] = "common_text_1388"
		;(nil)[3] = "common_text_1389"
		;(nil)[4] = "common_text_1390"
		;(nil)[5] = "common_text_1391"
		return nil
	end)
	equipDesRead:defineValue("qualityName", function()
		_UPVALUE0_ = nil
		;(nil)[0] = "common_text_1900"
		;(nil)[1] = "common_text_1901"
		;(nil)[2] = "common_text_1902"
		;(nil)[3] = "common_text_1903"
		;(nil)[4] = "common_text_1904"
		;(nil)[5] = "common_text_1905"
		return nil
	end)
	equipDesRead:defineValue("color", function()
		_UPVALUE0_ = nil
		;(nil)[0] = "frame_item_base_01.png"
		;(nil)[1] = "frame_item_base_02.png"
		;(nil)[2] = "frame_item_base_03.png"
		;(nil)[3] = "frame_item_base_04.png"
		;(nil)[4] = "frame_item_base_05.png"
		;(nil)[5] = "frame_item_base_06.png"
		;(nil)[888] = "frame_item_base_07.png"
		;(nil)[999] = "frame_item_base_07.png"
		return nil
	end)
	equipDesRead:defineValue("part", function()
		equipDesRead.part, equipDesRead = nil, nil
		for i = 1, 6 do
			equipDesRead.part[i] = "equip_0" .. i .. "_6" .. i .. "007.png"
		end
		return equipDesRead.part
	end)
	equipDesRead:defineValue("partGray", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "icon_lord_weapons.png"
		;(nil)[2] = "icon_lord_clothes.png"
		;(nil)[3] = "icon_lord_peeping.png"
		;(nil)[4] = "icon_lord_trousers.png"
		;(nil)[5] = "icon_lord_shoes.png"
		;(nil)[6] = "icon_lord_hand.png"
		;(nil)[7] = "icon_lord_ring.png"
		;(nil)[8] = "icon_lord_necklace.png"
		return nil
	end)
	equipDesRead:defineValue("partName", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1333"
		;(nil)[2] = "common_text_1335"
		;(nil)[3] = "common_text_1332"
		;(nil)[4] = "common_text_1334"
		;(nil)[5] = "common_text_1337"
		;(nil)[6] = "common_text_1336"
		;(nil)[7] = "equip_text_05"
		;(nil)[8] = "equip_text_32"
		return nil
	end)
	equipDesRead:defineValue("add", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1299"
		;(nil)[2] = "common_text_1300"
		;(nil)[3] = "common_text_1301"
		;(nil)[4] = "common_text_1302"
		;(nil)[5] = "common_text_1303"
		;(nil)[6] = "common_text_1304"
		;(nil)[11] = "common_text_1305"
		;(nil)[12] = "common_text_1306"
		;(nil)[13] = "common_text_149"
		;(nil)[14] = "common_text_1307"
		;(nil)[15] = "common_text_1308"
		;(nil)[16] = "common_text_1309"
		;(nil)[17] = "common_text_1310"
		;(nil)[18] = "common_text_1311"
		;(nil)[19] = "common_text_1312"
		;(nil)[20] = "common_text_1313"
		;(nil)[21] = "common_text_1314"
		;(nil)[22] = "common_text_1315"
		;(nil)[23] = "common_text_1316"
		;(nil)[24] = "common_text_1317"
		;(nil)[25] = "common_text_1318"
		;(nil)[26] = "common_text_1319"
		;(nil)[27] = "common_text_1320"
		;(nil)[28] = "common_text_1321"
		;(nil)[29] = "common_text_1322"
		;(nil)[30] = "common_text_1323"
		;(nil)[31] = "common_text_1324"
		;(nil)[32] = "common_text_1325"
		;(nil)[33] = "common_text_1326"
		;(nil)[34] = "common_text_1327"
		;(nil)[35] = "common_text_2440"
		;(nil)[36] = "common_text_2439"
		;(nil)[37] = "common_text_2441"
		;(nil)[38] = "common_text_2442"
		;(nil)[39] = "common_text_3795"
		;(nil)[40] = "common_text_3794"
		;(nil)[41] = "common_text_3793"
		;(nil)[42] = "common_text_3787"
		;(nil)[43] = "buff_des_06"
		;(nil)[44] = "common_text_1933"
		;(nil)[45] = "technology_name_24103"
		;(nil)[46] = "common_text_3788"
		;(nil)[47] = "common_text_2440"
		;(nil)[48] = "common_text_2440"
		;(nil)[49] = "common_text_2440"
		;(nil)[50] = "common_text_3466"
		;(nil)[51] = "common_text_2440"
		;(nil)[60] = "buff_des_08"
		;(nil)[61] = "buff_des_09"
		;(nil)[62] = "buff_des_10"
		;(nil)[63] = "buff_des_11"
		;(nil)[64] = "buff_des_12"
		;(nil)[65] = "buff_des_13"
		;(nil)[66] = "war_stone_name_19"
		;(nil)[67] = "buff_des_10"
		;(nil)[68] = "buff_des_11"
		;(nil)[69] = "buff_des_12"
		;(nil)[70] = "buff_des_13"
		;(nil)[71] = "buff_des_15"
		;(nil)[72] = "buff_des_16"
		;(nil)[73] = "common_text_3796"
		;(nil)[74] = "buff_des_14"
		;(nil)[75] = "common_text_2953"
		;(nil)[76] = "buff_des_17"
		;(nil)[77] = "buff_des_18"
		;(nil)[78] = "common_text_1911"
		;(nil)[79] = "war_stone_name_17"
		;(nil)[80] = "accessories_skill_01"
		;(nil)[81] = "accessories_skill_02"
		;(nil)[82] = "accessories_skill_03"
		;(nil)[83] = "accessories_skill_04"
		;(nil)[84] = "accessories_skill_05"
		;(nil)[85] = "accessories_skill_06"
		;(nil)[86] = "accessories_skill_07"
		;(nil)[87] = "war_stone_name_17"
		;(nil)[88] = "buff_des_19"
		;(nil)[89] = "buff_des_20"
		;(nil)[90] = "buff_des_21"
		;(nil)[91] = "buff_des_22"
		;(nil)[92] = "buff_des_23"
		;(nil)[93] = "buff_des_24"
		;(nil)[94] = "buff_des_25"
		;(nil)[95] = "buff_des_26"
		;(nil)[96] = "buff_des_27"
		;(nil)[97] = "buff_text_596"
		;(nil)[98] = "buff_des_98"
		return nil
	end)
	if commonCheck.ARTIFACT then
		equipDesRead.artifactInit()
	end
	function _ENV()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1299"
		;(nil)[2] = "common_text_1300"
		;(nil)[3] = "common_text_1301"
		;(nil)[4] = "common_text_1302"
		;(nil)[5] = "common_text_1303"
		;(nil)[6] = "common_text_1304"
		;(nil)[11] = "common_text_1305"
		;(nil)[12] = "common_text_1306"
		;(nil)[13] = "common_text_149"
		;(nil)[14] = "common_text_1307"
		;(nil)[15] = "common_text_1308"
		;(nil)[16] = "common_text_1309"
		;(nil)[17] = "common_text_1310"
		;(nil)[18] = "common_text_1311"
		;(nil)[19] = "common_text_1312"
		;(nil)[20] = "common_text_1313"
		;(nil)[21] = "common_text_1314"
		;(nil)[22] = "common_text_1315"
		;(nil)[23] = "common_text_1316"
		;(nil)[24] = "common_text_1317"
		;(nil)[25] = "common_text_1318"
		;(nil)[26] = "common_text_1319"
		;(nil)[27] = "common_text_1320"
		;(nil)[28] = "common_text_1321"
		;(nil)[29] = "common_text_1322"
		;(nil)[30] = "common_text_1323"
		;(nil)[31] = "common_text_1324"
		;(nil)[32] = "common_text_1325"
		;(nil)[33] = "common_text_1326"
		;(nil)[34] = "common_text_1327"
		;(nil)[35] = "common_text_2440"
		;(nil)[36] = "common_text_2439"
		;(nil)[37] = "common_text_2441"
		;(nil)[38] = "common_text_2442"
		;(nil)[39] = "common_text_3795"
		;(nil)[40] = "common_text_3794"
		;(nil)[41] = "common_text_3793"
		;(nil)[42] = "common_text_3787"
		;(nil)[43] = "buff_des_06"
		;(nil)[44] = "common_text_1933"
		;(nil)[45] = "technology_name_24103"
		;(nil)[46] = "common_text_3788"
		;(nil)[47] = "common_text_2440"
		;(nil)[48] = "common_text_2440"
		;(nil)[49] = "common_text_2440"
		;(nil)[50] = "common_text_3466"
		;(nil)[51] = "common_text_2440"
		;(nil)[60] = "buff_des_08"
		;(nil)[61] = "buff_des_09"
		;(nil)[62] = "buff_des_10"
		;(nil)[63] = "buff_des_11"
		;(nil)[64] = "buff_des_12"
		;(nil)[65] = "buff_des_13"
		;(nil)[66] = "war_stone_name_19"
		;(nil)[67] = "buff_des_10"
		;(nil)[68] = "buff_des_11"
		;(nil)[69] = "buff_des_12"
		;(nil)[70] = "buff_des_13"
		;(nil)[71] = "buff_des_15"
		;(nil)[72] = "buff_des_16"
		;(nil)[73] = "common_text_3796"
		;(nil)[74] = "buff_des_14"
		;(nil)[75] = "common_text_2953"
		;(nil)[76] = "buff_des_17"
		;(nil)[77] = "buff_des_18"
		;(nil)[78] = "common_text_1911"
		;(nil)[79] = "war_stone_name_17"
		;(nil)[80] = "accessories_skill_01"
		;(nil)[81] = "accessories_skill_02"
		;(nil)[82] = "accessories_skill_03"
		;(nil)[83] = "accessories_skill_04"
		;(nil)[84] = "accessories_skill_05"
		;(nil)[85] = "accessories_skill_06"
		;(nil)[86] = "accessories_skill_07"
		;(nil)[87] = "war_stone_name_17"
		;(nil)[88] = "buff_des_19"
		;(nil)[89] = "buff_des_20"
		;(nil)[90] = "buff_des_21"
		;(nil)[91] = "buff_des_22"
		;(nil)[92] = "buff_des_23"
		;(nil)[93] = "buff_des_24"
		;(nil)[94] = "buff_des_25"
		;(nil)[95] = "buff_des_26"
		;(nil)[96] = "buff_des_27"
		;(nil)[97] = "buff_text_596"
		;(nil)[98] = "buff_des_98"
		return nil
	end
	;(function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1299"
		;(nil)[2] = "common_text_1300"
		;(nil)[3] = "common_text_1301"
		;(nil)[4] = "common_text_1302"
		;(nil)[5] = "common_text_1303"
		;(nil)[6] = "common_text_1304"
		;(nil)[11] = "common_text_1305"
		;(nil)[12] = "common_text_1306"
		;(nil)[13] = "common_text_149"
		;(nil)[14] = "common_text_1307"
		;(nil)[15] = "common_text_1308"
		;(nil)[16] = "common_text_1309"
		;(nil)[17] = "common_text_1310"
		;(nil)[18] = "common_text_1311"
		;(nil)[19] = "common_text_1312"
		;(nil)[20] = "common_text_1313"
		;(nil)[21] = "common_text_1314"
		;(nil)[22] = "common_text_1315"
		;(nil)[23] = "common_text_1316"
		;(nil)[24] = "common_text_1317"
		;(nil)[25] = "common_text_1318"
		;(nil)[26] = "common_text_1319"
		;(nil)[27] = "common_text_1320"
		;(nil)[28] = "common_text_1321"
		;(nil)[29] = "common_text_1322"
		;(nil)[30] = "common_text_1323"
		;(nil)[31] = "common_text_1324"
		;(nil)[32] = "common_text_1325"
		;(nil)[33] = "common_text_1326"
		;(nil)[34] = "common_text_1327"
		;(nil)[35] = "common_text_2440"
		;(nil)[36] = "common_text_2439"
		;(nil)[37] = "common_text_2441"
		;(nil)[38] = "common_text_2442"
		;(nil)[39] = "common_text_3795"
		;(nil)[40] = "common_text_3794"
		;(nil)[41] = "common_text_3793"
		;(nil)[42] = "common_text_3787"
		;(nil)[43] = "buff_des_06"
		;(nil)[44] = "common_text_1933"
		;(nil)[45] = "technology_name_24103"
		;(nil)[46] = "common_text_3788"
		;(nil)[47] = "common_text_2440"
		;(nil)[48] = "common_text_2440"
		;(nil)[49] = "common_text_2440"
		;(nil)[50] = "common_text_3466"
		;(nil)[51] = "common_text_2440"
		;(nil)[60] = "buff_des_08"
		;(nil)[61] = "buff_des_09"
		;(nil)[62] = "buff_des_10"
		;(nil)[63] = "buff_des_11"
		;(nil)[64] = "buff_des_12"
		;(nil)[65] = "buff_des_13"
		;(nil)[66] = "war_stone_name_19"
		;(nil)[67] = "buff_des_10"
		;(nil)[68] = "buff_des_11"
		;(nil)[69] = "buff_des_12"
		;(nil)[70] = "buff_des_13"
		;(nil)[71] = "buff_des_15"
		;(nil)[72] = "buff_des_16"
		;(nil)[73] = "common_text_3796"
		;(nil)[74] = "buff_des_14"
		;(nil)[75] = "common_text_2953"
		;(nil)[76] = "buff_des_17"
		;(nil)[77] = "buff_des_18"
		;(nil)[78] = "common_text_1911"
		;(nil)[79] = "war_stone_name_17"
		;(nil)[80] = "accessories_skill_01"
		;(nil)[81] = "accessories_skill_02"
		;(nil)[82] = "accessories_skill_03"
		;(nil)[83] = "accessories_skill_04"
		;(nil)[84] = "accessories_skill_05"
		;(nil)[85] = "accessories_skill_06"
		;(nil)[86] = "accessories_skill_07"
		;(nil)[87] = "war_stone_name_17"
		;(nil)[88] = "buff_des_19"
		;(nil)[89] = "buff_des_20"
		;(nil)[90] = "buff_des_21"
		;(nil)[91] = "buff_des_22"
		;(nil)[92] = "buff_des_23"
		;(nil)[93] = "buff_des_24"
		;(nil)[94] = "buff_des_25"
		;(nil)[95] = "buff_des_26"
		;(nil)[96] = "buff_des_27"
		;(nil)[97] = "buff_text_596"
		;(nil)[98] = "buff_des_98"
		return nil
	end)[1] = "remake_equipment_lock"
	;(function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1299"
		;(nil)[2] = "common_text_1300"
		;(nil)[3] = "common_text_1301"
		;(nil)[4] = "common_text_1302"
		;(nil)[5] = "common_text_1303"
		;(nil)[6] = "common_text_1304"
		;(nil)[11] = "common_text_1305"
		;(nil)[12] = "common_text_1306"
		;(nil)[13] = "common_text_149"
		;(nil)[14] = "common_text_1307"
		;(nil)[15] = "common_text_1308"
		;(nil)[16] = "common_text_1309"
		;(nil)[17] = "common_text_1310"
		;(nil)[18] = "common_text_1311"
		;(nil)[19] = "common_text_1312"
		;(nil)[20] = "common_text_1313"
		;(nil)[21] = "common_text_1314"
		;(nil)[22] = "common_text_1315"
		;(nil)[23] = "common_text_1316"
		;(nil)[24] = "common_text_1317"
		;(nil)[25] = "common_text_1318"
		;(nil)[26] = "common_text_1319"
		;(nil)[27] = "common_text_1320"
		;(nil)[28] = "common_text_1321"
		;(nil)[29] = "common_text_1322"
		;(nil)[30] = "common_text_1323"
		;(nil)[31] = "common_text_1324"
		;(nil)[32] = "common_text_1325"
		;(nil)[33] = "common_text_1326"
		;(nil)[34] = "common_text_1327"
		;(nil)[35] = "common_text_2440"
		;(nil)[36] = "common_text_2439"
		;(nil)[37] = "common_text_2441"
		;(nil)[38] = "common_text_2442"
		;(nil)[39] = "common_text_3795"
		;(nil)[40] = "common_text_3794"
		;(nil)[41] = "common_text_3793"
		;(nil)[42] = "common_text_3787"
		;(nil)[43] = "buff_des_06"
		;(nil)[44] = "common_text_1933"
		;(nil)[45] = "technology_name_24103"
		;(nil)[46] = "common_text_3788"
		;(nil)[47] = "common_text_2440"
		;(nil)[48] = "common_text_2440"
		;(nil)[49] = "common_text_2440"
		;(nil)[50] = "common_text_3466"
		;(nil)[51] = "common_text_2440"
		;(nil)[60] = "buff_des_08"
		;(nil)[61] = "buff_des_09"
		;(nil)[62] = "buff_des_10"
		;(nil)[63] = "buff_des_11"
		;(nil)[64] = "buff_des_12"
		;(nil)[65] = "buff_des_13"
		;(nil)[66] = "war_stone_name_19"
		;(nil)[67] = "buff_des_10"
		;(nil)[68] = "buff_des_11"
		;(nil)[69] = "buff_des_12"
		;(nil)[70] = "buff_des_13"
		;(nil)[71] = "buff_des_15"
		;(nil)[72] = "buff_des_16"
		;(nil)[73] = "common_text_3796"
		;(nil)[74] = "buff_des_14"
		;(nil)[75] = "common_text_2953"
		;(nil)[76] = "buff_des_17"
		;(nil)[77] = "buff_des_18"
		;(nil)[78] = "common_text_1911"
		;(nil)[79] = "war_stone_name_17"
		;(nil)[80] = "accessories_skill_01"
		;(nil)[81] = "accessories_skill_02"
		;(nil)[82] = "accessories_skill_03"
		;(nil)[83] = "accessories_skill_04"
		;(nil)[84] = "accessories_skill_05"
		;(nil)[85] = "accessories_skill_06"
		;(nil)[86] = "accessories_skill_07"
		;(nil)[87] = "war_stone_name_17"
		;(nil)[88] = "buff_des_19"
		;(nil)[89] = "buff_des_20"
		;(nil)[90] = "buff_des_21"
		;(nil)[91] = "buff_des_22"
		;(nil)[92] = "buff_des_23"
		;(nil)[93] = "buff_des_24"
		;(nil)[94] = "buff_des_25"
		;(nil)[95] = "buff_des_26"
		;(nil)[96] = "buff_des_27"
		;(nil)[97] = "buff_text_596"
		;(nil)[98] = "buff_des_98"
		return nil
	end)[2] = true
	equipDesRead:defineValue("remakeLock", function()
		_UPVALUE0_ = nil
		;(nil)[1] = "common_text_1299"
		;(nil)[2] = "common_text_1300"
		;(nil)[3] = "common_text_1301"
		;(nil)[4] = "common_text_1302"
		;(nil)[5] = "common_text_1303"
		;(nil)[6] = "common_text_1304"
		;(nil)[11] = "common_text_1305"
		;(nil)[12] = "common_text_1306"
		;(nil)[13] = "common_text_149"
		;(nil)[14] = "common_text_1307"
		;(nil)[15] = "common_text_1308"
		;(nil)[16] = "common_text_1309"
		;(nil)[17] = "common_text_1310"
		;(nil)[18] = "common_text_1311"
		;(nil)[19] = "common_text_1312"
		;(nil)[20] = "common_text_1313"
		;(nil)[21] = "common_text_1314"
		;(nil)[22] = "common_text_1315"
		;(nil)[23] = "common_text_1316"
		;(nil)[24] = "common_text_1317"
		;(nil)[25] = "common_text_1318"
		;(nil)[26] = "common_text_1319"
		;(nil)[27] = "common_text_1320"
		;(nil)[28] = "common_text_1321"
		;(nil)[29] = "common_text_1322"
		;(nil)[30] = "common_text_1323"
		;(nil)[31] = "common_text_1324"
		;(nil)[32] = "common_text_1325"
		;(nil)[33] = "common_text_1326"
		;(nil)[34] = "common_text_1327"
		;(nil)[35] = "common_text_2440"
		;(nil)[36] = "common_text_2439"
		;(nil)[37] = "common_text_2441"
		;(nil)[38] = "common_text_2442"
		;(nil)[39] = "common_text_3795"
		;(nil)[40] = "common_text_3794"
		;(nil)[41] = "common_text_3793"
		;(nil)[42] = "common_text_3787"
		;(nil)[43] = "buff_des_06"
		;(nil)[44] = "common_text_1933"
		;(nil)[45] = "technology_name_24103"
		;(nil)[46] = "common_text_3788"
		;(nil)[47] = "common_text_2440"
		;(nil)[48] = "common_text_2440"
		;(nil)[49] = "common_text_2440"
		;(nil)[50] = "common_text_3466"
		;(nil)[51] = "common_text_2440"
		;(nil)[60] = "buff_des_08"
		;(nil)[61] = "buff_des_09"
		;(nil)[62] = "buff_des_10"
		;(nil)[63] = "buff_des_11"
		;(nil)[64] = "buff_des_12"
		;(nil)[65] = "buff_des_13"
		;(nil)[66] = "war_stone_name_19"
		;(nil)[67] = "buff_des_10"
		;(nil)[68] = "buff_des_11"
		;(nil)[69] = "buff_des_12"
		;(nil)[70] = "buff_des_13"
		;(nil)[71] = "buff_des_15"
		;(nil)[72] = "buff_des_16"
		;(nil)[73] = "common_text_3796"
		;(nil)[74] = "buff_des_14"
		;(nil)[75] = "common_text_2953"
		;(nil)[76] = "buff_des_17"
		;(nil)[77] = "buff_des_18"
		;(nil)[78] = "common_text_1911"
		;(nil)[79] = "war_stone_name_17"
		;(nil)[80] = "accessories_skill_01"
		;(nil)[81] = "accessories_skill_02"
		;(nil)[82] = "accessories_skill_03"
		;(nil)[83] = "accessories_skill_04"
		;(nil)[84] = "accessories_skill_05"
		;(nil)[85] = "accessories_skill_06"
		;(nil)[86] = "accessories_skill_07"
		;(nil)[87] = "war_stone_name_17"
		;(nil)[88] = "buff_des_19"
		;(nil)[89] = "buff_des_20"
		;(nil)[90] = "buff_des_21"
		;(nil)[91] = "buff_des_22"
		;(nil)[92] = "buff_des_23"
		;(nil)[93] = "buff_des_24"
		;(nil)[94] = "buff_des_25"
		;(nil)[95] = "buff_des_26"
		;(nil)[96] = "buff_des_27"
		;(nil)[97] = "buff_text_596"
		;(nil)[98] = "buff_des_98"
		return nil
	end)
end
function equipDesRead.artifactInit()
	equipDesRead:defineValue("kingequipup", function()
		equipDesRead.kingequipup, equipDesRead = nil, nil
		local kingequip = require_once("app." .. LocalTblPath .. ".config_server.equipment_kingequip_up")
		for k, v in pairs(kingequip) do
			v.mainMaterialID = v.mainMaterial[1]
			v.mainMaterialQuality = v.mainMaterial[2]
			equipDesRead.kingequipup[v.equipmentID] = v
		end
		return equipDesRead.kingequipup
	end)
	equipDesRead, equipDesRead = equipDesRead, equipDesRead.defineValue
	equipDesRead.awakenShopItem = 241701
	equipDesRead.sound = "shu"
	equipDesRead.csb = "gEAction_7"
	equipDesRead, equipDesRead.png = "kingequipup", "6700121.png"
	;("kingequipup").x = 0.21
	equipDesRead, equipDesRead.defineValue[6100131], equipDesRead.scale, ("kingequipup").y = equipDesRead, equipDesRead, "kingequipup", 0.2
	equipDesRead.awakenShopItem = 241401
	equipDesRead.sound = "jian"
	equipDesRead.csb = "gEAction_2"
	equipDesRead, equipDesRead.png = "kingequipup", "6200121.png"
	;("kingequipup").x = 0.19
	equipDesRead, equipDesRead.defineValue[6200131], equipDesRead.scale, ("kingequipup").y = equipDesRead, equipDesRead, "kingequipup", 0.26
	equipDesRead.awakenByGift = true
	equipDesRead.sound = "gong"
	equipDesRead.csb = "gEAction_10"
	equipDesRead, equipDesRead.png = "kingequipup", "Background_SBrmxy_010.png"
	;("kingequipup").x = 0.15
	equipDesRead, equipDesRead.defineValue[6300131], equipDesRead.scale, ("kingequipup").y = equipDesRead, equipDesRead, "kingequipup", 0.3
	equipDesRead.awakenShopItem = 241501
	equipDesRead.unlockShopItem = 241601
	equipDesRead.sound = "futou"
	equipDesRead.csb = "gEAction_4"
	equipDesRead, equipDesRead.png = "kingequipup", "6400121.png"
	;("kingequipup").x = 0.18
	equipDesRead, equipDesRead.defineValue[6400131], equipDesRead.scale, ("kingequipup").y = equipDesRead, equipDesRead, "kingequipup", 0.27
	equipDesRead.awakenByGift = true
	equipDesRead.unlockByGift = true
	equipDesRead.sound = "qizhi"
	equipDesRead.csb = "gEAction_9"
	equipDesRead, equipDesRead.png = "kingequipup", "6900121.png"
	;("kingequipup").x = 0.19
	equipDesRead.scale, ("kingequipup").y = "kingequipup", 0.18
	equipDesRead.skel = "spine/qizi.skel"
	equipDesRead.defineValue[6500131], equipDesRead.atlas = equipDesRead, "spine/qizi.atlas"
	local artifactNode = equipDesRead.defineValue
	equipDesRead:defineValue("artifactAttr", function()
		local attrdata = require_once("app." .. LocalTblPath .. ".config_server.artifact_attributes_config")
		equipDesRead.artifactAttr, _ENV = "app." .. LocalTblPath .. ".config_server.artifact_attributes_config", "app." .. LocalTblPath .. ".config_server.artifact_attributes_config"
		for i, v in ipairs(attrdata) do
			if equipDesRead.artifactAttr[v.skillID] == nil then
				equipDesRead.artifactAttr[v.skillID], _ENV = nil, nil
			end
			if equipDesRead.artifactAttr[v.skillID][v.lv] == nil then
				equipDesRead.artifactAttr[v.skillID][v.lv], _ENV = nil, nil
			end
			equipDesRead.artifactAttr[v.skillID][v.lv][v.awakeType] = v
		end
		return equipDesRead.artifactAttr
	end)
	equipDesRead:defineValue("artifactActiveSkill", function()
		local activeskillDesdata = require_once("app." .. LocalTblPath .. ".config_client.artifact_activeskill_view")
		local activeskilldata = require_once("app." .. LocalTblPath .. ".config_server.artifact_activeskill_config")
		equipDesRead.artifactActiveSkill, _ENV = "app." .. LocalTblPath .. ".config_server.artifact_activeskill_config", "app." .. LocalTblPath .. ".config_server.artifact_activeskill_config"
		for i, v in ipairs(activeskilldata) do
			equipDesRead.artifactActiveSkill[v.weaponID] = v
			for k, value in pairs(activeskillDesdata[i]) do
				equipDesRead.artifactActiveSkill[v.weaponID][k] = value
			end
		end
		return equipDesRead.artifactActiveSkill
	end)
	local createArtifactData = function(name)
		equipDesRead.unlockAndImmedItems, equipDesRead, equipDesRead.artifact, equipDesRead = nil, nil, nil, nil
		local data = require_once("app." .. LocalTblPath .. ".config_client.artifact_describe_config")
		local unlockdata = require_once("app." .. LocalTblPath .. ".config_server.artifact_unlock_config")
		for k, v in pairs(data) do
			equipDesRead.artifact[v.ID] = v
			equipDesRead.artifact[v.ID].actionNode = artifactNode[v.weaponID]
		end
		for k, v in pairs(unlockdata) do
			if equipDesRead.artifact[v.ID] then
				local weaponID = equipDesRead.artifact[v.ID].weaponID
				_UPVALUE3_ = nil
				;(nil)[1] = "type"
				;(nil)[2] = "id"
				;(nil)[3] = "value"
				equipDesRead.artifact[v.ID].unlockCondition = serviceFunctions.tableFormat(v.unlockCondition, nil)
				_UPVALUE3_ = nil
				;(nil)[1] = "type"
				;(nil)[2] = "id"
				;(nil)[3] = "value"
				equipDesRead.artifact[v.ID].immedCondition = serviceFunctions.tableFormat(v.immedCondition, nil)
				equipDesRead.artifact[v.ID].isLock = true
				equipDesRead.artifact[v.ID].info, equipDesRead = v.ID, v.ID
				equipDesRead.artifact[v.ID].info.skillList, equipDesRead = v.ID, v.ID
				for _, v1 in ipairs(equipDesRead.artifact[v.ID].unlockCondition) do
					if v1.type == 4 then
						equipDesRead.unlockAndImmedItems[v1.id] = weaponID
					end
				end
				for _, v1 in ipairs(equipDesRead.artifact[v.ID].immedCondition) do
					if v1.type == 4 then
						equipDesRead.unlockAndImmedItems[v1.id] = weaponID
					end
				end
				for i = 1, 4 do
					local skillID = tostring(weaponID) .. tostring(i)
					equipDesRead = v.ID
					v.ID.isActive = false
					v.ID.skillID = tonumber(skillID)
					equipDesRead.artifact[v.ID].info.skillList[skillID], v.ID.activeLevel = v.ID, equipDesRead.artifactAttr[tonumber(skillID)][1][0].init_skill
				end
				equipDesRead.artifact[v.ID].info.level = 0
				equipDesRead.artifact[v.ID].info.awakeStatus = 0
				equipDesRead.artifact[v.ID].info.exp = 0
				equipDesRead.artifact[v.ID].info.armsID = weaponID
				equipDesRead, equipDesRead = 1, v.ID
				;(1).activeLevel = equipDesRead.artifactActiveSkill[weaponID].init_skill
				;(1).isActive = false
				equipDesRead.artifact[v.ID].info.activeSkillList, v.ID[1], (1).skillID = v.ID, 1, equipDesRead.artifactActiveSkill[weaponID].skillID
			end
		end
		if name == "artifact" then
			return equipDesRead.artifact
		elseif name == "unlockAndImmedItems" then
			return equipDesRead.unlockAndImmedItems
		end
	end
	equipDesRead:defineValue("artifact", createArtifactData)
	equipDesRead:defineValue("unlockAndImmedItems", createArtifactData)
	_UPVALUE2_ = createArtifactData
	createArtifactData[1] = "equipment_with_quality_config"
	createArtifactData[2] = true
	equipDesRead:defineValue("equipQualityConfig", createArtifactData)
	equipDesRead:defineValue("equipQualityMap", function()
		local config = require_data("equipment_with_quality_config", true, true).data
		local _ENV, ret = "equipment_with_quality_config", "equipment_with_quality_config"
		for _, v in pairs(config) do
			ret[v.equipmentID] = v
		end
		return ret
	end)
	equipDesRead:defineValue("artifactLevel", function()
		local levelData = require_once("app." .. LocalTblPath .. ".config_server.artifact_level_config")
		equipDesRead.artifactLevel, _ENV = "app." .. LocalTblPath .. ".config_server.artifact_level_config", "app." .. LocalTblPath .. ".config_server.artifact_level_config"
		for i, v in ipairs(levelData) do
			if equipDesRead.artifactLevel[v.weaponID] == nil then
				equipDesRead.artifactLevel[v.weaponID], _ENV = nil, nil
			end
			equipDesRead.artifactLevel[v.weaponID][v.lv] = v
		end
		return equipDesRead.artifactLevel
	end)
	equipDesRead:defineValue("artifactSkillDes", function()
		local skillDesdata = require_once("app." .. LocalTblPath .. ".config_client.artifact_skill_view")
		equipDesRead.artifactSkillDes, _ENV = "app." .. LocalTblPath .. ".config_client.artifact_skill_view", "app." .. LocalTblPath .. ".config_client.artifact_skill_view"
		for k, v in pairs(skillDesdata) do
			equipDesRead.artifactSkillDes[v.skillID] = v
		end
		return equipDesRead.artifactSkillDes
	end)
	equipDesRead:defineValue("artifactExpcrit", function()
		local expcritData = require_once("app." .. LocalTblPath .. ".config_server.artifact_expcrit_config")
		equipDesRead.artifactExpcrit, _ENV = "app." .. LocalTblPath .. ".config_server.artifact_expcrit_config", "app." .. LocalTblPath .. ".config_server.artifact_expcrit_config"
		for k, v in pairs(expcritData) do
			if v.type == 3 then
				table.insert(equipDesRead.artifactExpcrit, v)
			end
		end
		table.sort(equipDesRead.artifactExpcrit, function(l, r)
			return l.num < r.num
		end)
		return equipDesRead.artifactExpcrit
	end)
	equipDesRead:defineValue("artifactAwakeSkill", function()
		local awakeskillDesdata = require_once("app." .. LocalTblPath .. ".config_client.artifact_awakeskill_view")
		equipDesRead.artifactAwakeSkill, _ENV = "app." .. LocalTblPath .. ".config_client.artifact_awakeskill_view", "app." .. LocalTblPath .. ".config_client.artifact_awakeskill_view"
		for i, v in ipairs(awakeskillDesdata) do
			equipDesRead.artifactAwakeSkill[v.weaponID] = v
		end
		return equipDesRead.artifactAwakeSkill
	end)
	equipDesRead:defineValue("artifactAwake", function()
		local awakedata = require_once("app." .. LocalTblPath .. ".config_server.artifact_awake_config")
		equipDesRead.artifactAwake, _ENV = "app." .. LocalTblPath .. ".config_server.artifact_awake_config", "app." .. LocalTblPath .. ".config_server.artifact_awake_config"
		for i, v in ipairs(awakedata) do
			equipDesRead.artifactAwake[v.weaponID] = v
		end
		return equipDesRead.artifactAwake
	end)
end
init()
function equipDesRead.getShareInfo(weaponID)
	local _ENV, ret
	for i, v in ipairs(equipDesRead.artifact) do
		if v.weaponID == weaponID then
			ret = serviceFunctions.table_copy_table(v)
			break
		end
	end
	return ret
end
function equipDesRead.getArtifactSkillName(skillID, isAwake)
	return isAwake and i18n(equipDesRead.artifactSkillDes[skillID].awakeDes) or i18n(equipDesRead.artifactSkillDes[skillID].des)
end
function equipDesRead.isArtifactSkillShowInMail(skillID)
	return equipDesRead.artifactSkillDes[skillID].isShow
end
function equipDesRead.getArtifactActiveSkill(weaponID)
	return equipDesRead.artifactActiveSkill[weaponID]
end
function equipDesRead.getArtifactAttrInfo(attrid, lv, awakeType)
	if equipDesRead.artifactAttr[attrid] then
		if equipDesRead.artifactAttr[attrid][lv] then
			return equipDesRead.artifactAttr[attrid][lv][awakeType]
		else
			return equipDesRead.artifactAttr[attrid][1][awakeType]
		end
	else
		print("getArtifactAttrInfo err attrid:", attrid)
		return equipDesRead.artifactAttr[61001311][1][0]
	end
end
function equipDesRead.calcMustCritTimes(curRefineTimes)
	local maxCount = 0
	local maxWeight = 0
	for i, v in ipairs(equipDesRead.artifactExpcrit) do
		if curRefineTimes < v.num then
			return v.num - curRefineTimes, v.Weight[1]
		end
		if maxCount < v.num then
			maxCount = v.num
			maxWeight = v.Weight[1]
		end
	end
	return 10 - math.fmod(curRefineTimes, 10), maxWeight
end
function equipDesRead.getArtifactAwakeSkillInfo(weaponID)
	return equipDesRead.artifactAwakeSkill[weaponID]
end
function equipDesRead.getArtifactAwakeInfo(weaponID)
	return equipDesRead.artifactAwake[weaponID].itemID
end
function equipDesRead.getArtifactMaxRefineTimes()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local vipLocalData = include("vipLocalData")
	local vipInfo = lordInfoCtrl:getVipDetails()
	local buffRet, buffRetKey = vipLocalData.queryVipBuffData(vipInfo.level)
	local extraAddCount = buffRetKey[7234] and buffRetKey[7234].value or 0
	return extraAddCount
end
function equipDesRead.getArtifactInfo()
	return equipDesRead.artifact
end
function equipDesRead.getArtifactWeaponIDByItem(id)
	dump(equipDesRead.unlockItemToWeaponCfg, "equipDesRead.unlockItemToWeaponCfg=====" .. id)
	return equipDesRead.unlockItemToWeaponCfg[id]
end
function equipDesRead.getArtifactPower(weaponID, lv)
	return equipDesRead.artifactLevel[weaponID][lv].power
end
function equipDesRead.getArtifactExp(weaponID, lv)
	return equipDesRead.artifactLevel[weaponID][lv].upgradeItem
end
function equipDesRead.getArtifactName(weaponID)
	for i, v in ipairs(equipDesRead.artifact) do
		if v.weaponID == weaponID then
			return i18n(v.name)
		end
	end
	return "???"
end
function equipDesRead.getRefineCost(times, total)
	local costCount = 0
	for i = 1, total do
		costCount = costCount + 20 + 5 * (times + i - 1)
	end
	return costCount
end
function equipDesRead.getArtifactIcon(weaponID)
	for i, v in ipairs(equipDesRead.artifact) do
		if v.weaponID == weaponID then
			return v.icon
		end
	end
	return "???"
end
function equipDesRead.getFactoryList(quality)
	local _ENV, ret
	for i, v in ipairs(equipDesRead.factory) do
		if quality == nil or quality == v.material_quality then
			_ENV = nil
			;(nil).mid = v.material_ID
			;(nil).time = v.time
			table.insert(ret, nil)
		end
	end
	return ret
end
function equipDesRead.getMQualityName(qid)
	qid = tonumber(qid)
	return i18n(equipDesRead.mQualityName[qid])
end
function equipDesRead.getQualityName(qid)
	qid = tonumber(qid)
	return i18n(equipDesRead.qualityName[qid])
end
function equipDesRead:getNormalColor()
	return cc.c3b(255, 200, 100)
end
function equipDesRead.getPartName(pid)
	pid = tonumber(pid)
	return i18n(equipDesRead.partName[pid])
end
function equipDesRead.getAttrColor(quality)
	local color = display.COLOR_BLACK
	if quality then
		color = equipDesRead.attrColor[quality]
	end
	return color
end
function equipDesRead.getAttrName(pid, value, isSplit)
	pid = tonumber(pid)
	if pid == 0 then
		return ""
	end
	local isSplit = isSplit and isSplit == true
	if value then
		value = type(value) == "number" and value / 10 or value
		if pid == 60 or pid == 61 then
			if isSplit then
				_ENV = nil
				;(nil).num = 30
				return i18n(equipDesRead.add[pid], nil), "+" .. value .. "%"
			else
				_ENV = value
				_ENV = nil
				;(nil).num = 30
				value.title = i18n(equipDesRead.add[pid], nil)
				value.value = value
				return i18n("common_text_1298", value)
			end
		elseif 61 < pid and pid < 66 then
			if isSplit then
				_ENV = value
				value.num = 10
				return i18n(equipDesRead.add[pid], value), "+" .. value .. "%"
			else
				_ENV = value
				_ENV = nil
				;(nil).num = 10
				value.title = i18n(equipDesRead.add[pid], nil)
				value.value = value
				return i18n("common_text_1298", value)
			end
		elseif 66 < pid and pid < 71 then
			if isSplit then
				_ENV = value
				value.num = 11
				return i18n(equipDesRead.add[pid], value), "+" .. value .. "%"
			else
				_ENV = value
				_ENV = nil
				;(nil).num = 11
				value.title = i18n(equipDesRead.add[pid], nil)
				value.value = value
				return i18n("common_text_1298", value)
			end
		elseif pid == 42 then
			if isSplit then
				return i18n(equipDesRead.add[pid]), "+" .. value * 10 .. "s"
			else
				return i18n(equipDesRead.add[pid]) .. "+" .. value * 10 .. "s"
			end
		elseif pid == 74 or pid == 79 or pid == 78 then
			if isSplit then
				return i18n(equipDesRead.add[pid]), "+" .. value * 10
			else
				return i18n(equipDesRead.add[pid]) .. "+" .. value * 10
			end
		elseif pid == 84 or pid == 85 or pid == 86 then
			if isSplit then
				return i18n(equipDesRead.add[pid]), string.format("+%0.2f", value / 100)
			else
				return i18n(equipDesRead.add[pid]) .. string.format(" +%0.2f", value / 100)
			end
		elseif isSplit then
			return i18n(equipDesRead.add[pid]), "+" .. value .. "%"
		else
			_ENV = value
			value.title = i18n(equipDesRead.add[pid])
			value.value = value
			return i18n("common_text_1298", value)
		end
	elseif pid == 60 or pid == 61 then
		_ENV = value
		value.num = 30
		return i18n(equipDesRead.add[pid], value)
	elseif 61 < pid and pid < 66 then
		_ENV = value
		value.num = 10
		return i18n(equipDesRead.add[pid], value)
	elseif 66 < pid and pid < 71 then
		_ENV = value
		value.num = 11
		return i18n(equipDesRead.add[pid], value)
	else
		return i18n(equipDesRead.add[pid])
	end
end
function equipDesRead.getBg(quality, fromMemory)
	quality = tonumber(quality)
	if fromMemory then
		return "#" .. equipDesRead.color[quality]
	end
	if equipDesRead.color[quality] then
		return equipDesRead.color[quality]
	else
		return "frame_item_base_01.png"
	end
end
function equipDesRead.getBgByID(eid, fromMemory)
	eid = tonumber(eid)
	local equipmentltCtrl = include("equipmentltCtrl")
	local equip = equipmentltCtrl.getEquipCfg(eid)
	local quality = tonumber(equip.quality)
	if fromMemory then
		return "#" .. equipDesRead.color[quality]
	end
	if equipDesRead.color[quality] then
		return equipDesRead.color[quality]
	else
		return "frame_item_base_01.png"
	end
end
function equipDesRead.getName(eid)
	eid = tonumber(eid)
	if not equipDesRead.base[eid] then
		return eid
	end
	return i18n(equipDesRead.base[eid].name)
end
function equipDesRead.getDes(eid, quality)
	eid = tonumber(eid)
	local equipmentltCtrl = include("equipmentltCtrl")
	local baseProperty, mayVal = equipmentltCtrl.getEquipmentBaseProperty(eid, quality, 0)
	local baseString = equipDesRead.getAttrName(baseProperty, mayVal)
	return baseString
end
function equipDesRead.getPartGrayIcon(pid, fromMemory)
	pid = tonumber(pid)
	if fromMemory then
		return "#" .. equipDesRead.partGray[pid]
	end
	if equipDesRead.partGray[pid] then
		return equipDesRead.partGray[pid]
	else
		return "iron_lord_lock.png"
	end
end
function equipDesRead.getPartIcon(pid, fromMemory)
	pid = tonumber(pid)
	if fromMemory then
		return "#" .. equipDesRead.part[pid]
	end
	if equipDesRead.part[pid] then
		return equipDesRead.part[pid]
	else
		return "icon_item_common.png"
	end
end
function equipDesRead.getIcon(eid, fromMemory)
	eid = tonumber(eid)
	if fromMemory then
		return "#" .. equipDesRead.base[eid].icon
	end
	if equipDesRead.base[eid] then
		return equipDesRead.base[eid].icon
	else
		return "icon_item_common.png"
	end
end
function equipDesRead.getBgByLv(lv)
	lv = tonumber(lv) + 1
	if lv >= BG_MIN_QUALITY and lv <= BG_MAX_QUALITY then
		return "frame_item_base_0" .. lv .. ".png"
	else
		return "frame_item_base_01.png"
	end
end
function equipDesRead.getSuitInfoList()
	local equipDesRead, ret
	if not equipDesRead.suitInfoList then
		for k, v in pairs(equipDesRead.base) do
			if v.suitequipID > 0 then
				if not ret[v.suitequipID] then
					ret[v.suitequipID], equipDesRead = nil, nil
				end
				if not v.equipid then
					v.equipid = k
				end
				table.insert(ret[v.suitequipID], v)
			end
		end
		for k, v in pairs(ret) do
			table.sort(ret[k], function(l, r)
				return l.equipid < r.equipid
			end)
		end
		equipDesRead.suitInfoList = ret
	else
		ret = equipDesRead.suitInfoList
	end
	return ret
end
function equipDesRead.getSuitInfoByID(suitID)
	local ret = equipDesRead.getSuitInfoList()
	return ret[suitID]
end
function equipDesRead.getSuitTendencyByID(suitequipID)
	local suitName = "suit_equipname_01"
	local propertyName = "suit_propertyname_01"
	local info = equipDesRead.tendency[suitequipID]
	if info then
		suitName = info.suitequipname
		propertyName = info.propertyname
	end
	return suitName, propertyName
end
function equipDesRead.getSuitpropertyDes(pType, value, dataType)
	if pType == 42 or pType == 46 then
		return value .. "s"
	elseif pType == 84 or pType == 85 or pType == 86 then
		return string.format("%0.2f", value / 1000)
	elseif pType == 74 or pType == 78 or pType == 79 then
		return value
	elseif dataType == 2 then
		return value
	else
		return string.format("%0.2f%%", value / 10)
	end
end
function equipDesRead.getRealEquipIDAndQuality(id)
	if equipDesRead.equipQualityConfig[id] then
		return equipDesRead.equipQualityConfig[id].equipmentID, equipDesRead.equipQualityConfig[id].quality
	end
	return id
end
function equipDesRead.getEquipQuality(compoundID)
	if equipDesRead.equipQualityConfig[compoundID] then
		return equipDesRead.equipQualityConfig[compoundID].quality
	end
	if equipDesRead.equipQualityMap[compoundID] then
		return equipDesRead.equipQualityMap[compoundID].quality
	end
	return 0
end
function equipDesRead.getKingEquipConfig(equipmentID)
	local config
	for k, v in pairs(equipDesRead.kingequipup) do
		if v.mainMaterialID == equipmentID then
			config = v
			break
		end
	end
	return config
end
function equipDesRead.getKingEquipMaterial(equipmentID)
	local ret = 0
	local config = equipDesRead.getKingEquipConfig(equipmentID)
	if config then
		ret = config.material[2]
	end
	return ret
end
function equipDesRead.getKingEquipMaterialID(equipmentID)
	local ret = 0
	local config = equipDesRead.getKingEquipConfig(equipmentID)
	if config then
		ret = config.material[1]
	end
	return ret
end
function equipDesRead.getAttributeGroupCfg()
	return equipDesRead.property_prompt
end
function equipDesRead.getPropertyType(index)
	local cfg = equipDesRead.property_prompt[index]
	return cfg and cfg.propertyType or nil
end
function equipDesRead.getPropertyIsShow(cfg, quality)
	if not cfg then
		return false
	end
	if quality == gQualityDef.LEGEND or quality == gQualityDef.NEBULA then
		quality = gQualityDef.GOLD
	end
	for i, v in ipairs(cfg.equip) do
		if v == quality then
			return true
		end
	end
	return false
end
function equipDesRead.Item2UnlockEquipID(itemID)
	return equipDesRead.unlockAndImmedItems[itemID]
end
function equipDesRead.getMaxSelectNum(quality)
	_ENV = nil
	;(nil)[gQualityDef.GREEN] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_1"
	;(nil)[gQualityDef.BLUE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_2"
	;(nil)[gQualityDef.PURPLE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_3"
	;(nil)[gQualityDef.ORANGE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_4"
	;(nil)[gQualityDef.NEBULA] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_888"
	local (nil)[gQualityDef.LEGEND], qualityCountCfg = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_999", nil
	return include("constantRead").getConstValue(qualityCountCfg[quality]) or 1
end
function equipDesRead.getLockCostByNum(num)
	return equipDesRead.remakeLock[num].lockCost
end
function equipDesRead.getEquipQualityCfgID(id)
	return equipDesRead.equipQualityConfig[id] and equipDesRead.equipQualityConfig[id].equipmentID
end
function equipDesRead.getEquipQualityCompoundIDID(equipmentID)
	return equipDesRead.equipQualityMap[equipmentID] and equipDesRead.equipQualityMap[equipmentID].compoundID
end
function equipDesRead.getEquipQualityCfg()
	return equipDesRead.equipQualityConfig
end
return equipDesRead
