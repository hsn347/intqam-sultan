local baseComponent = require("fgui.base.baseComponent")
local WorldMapExplainSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMap/WorldMapExplainSingle", WorldMapExplainSingle)
function WorldMapExplainSingle:onInit()
end
function WorldMapExplainSingle:onShow()
end
function WorldMapExplainSingle:initData(explainData, instanceType, classId)
	self.fields.Text_title:setString(i18n(explainData.stepName))
	self.fields.Text_explain:setString(i18n(explainData.stepDesc))
	if instanceType == gMapObjTypeDef.roaringFlameWarBuilding then
		self.fields.Text_explain:setAutoSize(fgui.AutoSizeType.HEIGHT)
		local totalH = self.fields.Text_explain:getHeight() + 252
		self:setHeight(totalH)
	end
	local contentItem = fgui.UIPackage:getItemURL("WorldMap", explainData.stepPic)
	if contentItem == "" then
		local imageName = explainData.stepPic
		if string.sub(imageName, -4, -1) ~= ".png" then
			imageName = string.format("%s.png", explainData.stepPic)
		end
		self.fields.Image_demo:setURL(imageName)
		return
	else
		self.fields.Image_demo:setURL(string.format("ui://WorldMap/%s", explainData.stepPic))
	end
	local imageNode = self.fields.Image_demo:getComponent()
	if explainData.stepPic == "mapguide_step_02" then
		local Text_fastPick = imageNode:getChildByName("Text_fastPick")
		if Text_fastPick then
			Text_fastPick:setString(i18n("common_text_852"))
		end
		local Text_dispatch = imageNode:getChildByName("Text_dispatch")
		if Text_dispatch then
			Text_dispatch:setString(i18n("common_text_481"))
		end
		local Text_time = imageNode:getChildByName("Text_time")
		if Text_time then
			Text_time:setString("00:22:56")
		end
		local Text_weight = imageNode:getChildByName("Text_weight")
		if Text_weight then
			Text_weight:setString("473,791")
		end
		local Text_army = imageNode:getChildByName("Text_army")
		if Text_army then
			Text_army:setString("33726/34500")
		end
	elseif explainData.stepPic == "mapguide_step_14" then
		_UPVALUE4_ = explainData.stepPic
		explainData.stepPic[1] = 1
		explainData.stepPic[2] = 7
		explainData.stepPic[3] = 8
		local explainData.stepPic[4], nums = 12, explainData.stepPic
		for _, v in ipairs(nums) do
			local Text_num = imageNode:getChildByName("Text_" .. v)
			if Text_num then
				Text_num:setString(v)
			end
		end
	elseif explainData.stepPic == "mapguide_step_26" then
		_UPVALUE4_ = explainData.stepPic
		explainData.stepPic[1] = 1
		explainData.stepPic[2] = 7
		explainData.stepPic[3] = 8
		local explainData.stepPic[4], nums = 12, explainData.stepPic
		for _, v in ipairs(nums) do
			local Text_num = imageNode:getChildByName("Text_" .. v)
			if Text_num then
				Text_num:setString("1")
			end
		end
		local setIconBg = function(name, imageHdBg, imageBg, hasHD)
			local bg = hasHD and imageHdBg or imageBg
			local icon_monster_my = imageNode:getChildByName(name)
			if icon_monster_my then
				icon_monster_my:setURL(bg)
			end
		end
		local hasHD = worldMapDefine.hasBossHdRes()
		setIconBg("Sprite_monster_zjssg", "zjssg_gj_ws_01.png", "zjssg_gj_ws.png", hasHD)
		setIconBg("Sprite_monster_my", "my_gj_ws_01.png", "my_gj_ws.png", hasHD)
	elseif explainData.stepPic == "mapguide_step_29" then
		local radianceWarRead = include("radianceWarRead")
		local titleName = radianceWarRead.getResourceName(classId)
		_ENV = "my_gj_ws.png"
		;("my_gj_ws.png").name = titleName
		self.fields.Text_title:setString(i18n(explainData.stepName, "my_gj_ws.png"))
		local icon_build = imageNode:getChildByName("Map_build")
		if icon_build then
			icon_build:setURL(radianceWarRead.getResourceImageName(classId))
			local x, y = radianceWarRead.getResourceTpyePos(classId)
			local pos = icon_build:getPosition()
			print("posX,posY", pos.x, pos.y)
			icon_build:setPosition(cc.p(pos.x + x, pos.y - y))
		end
	elseif classId == 103 then
		local build_iamge = imageNode:getChildByName("Pyramid_build_small_4")
		if build_iamge then
			_ENV = imageNode
			imageNode.mapguide_step_31 = gMapObjTypeDef.mapTypeRadianceWarBeacon
			imageNode.mapguide_step_32 = 999
			imageNode.mapguide_step_33 = gMapObjTypeDef.mapTypeRadianceWarGate
			local imageNode.mapguide_step_34, stepPic2objType = gMapObjTypeDef.mapTypeRadianceWarPalace, imageNode
			local objType = stepPic2objType[explainData.stepPic] or gMapObjTypeDef.mapTypeRadianceWarGate
			local radianceWarRead = include("radianceWarRead")
			local icon = radianceWarRead.getBuildIcon(objType)
			build_iamge:setURL(icon)
		end
	end
end
return WorldMapExplainSingle
