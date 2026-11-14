local wrathBeastAwardSingle = class("wrathBeastAwardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("wrathBeastAwardSingle")
	end
	return target
end)
function wrathBeastAwardSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Text_des = SoraDChangeTextToHtml(self.Text_des)
	self.Text_des:setTextHorizontalAlignment(SoraDFLabelR())
	self.Text_des:setColor(cc.c3b(255, 255, 255))
end
function wrathBeastAwardSingle:initData(data, otherData)
	self.scroll = otherData.scroll
	self.view = otherData.view
	local award = data.reward
	if type(data.reward[1]) == "number" then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		award = serviceFunctions.tableFormat(data.reward, nil)
	end
	for k, v in ipairs(award) do
		if not self.itemArray[k] then
			self.itemArray[k] = include("commonItemAward").new()
			self.itemArray[k]:setScale(0.8)
			self.itemArray[k]:setBaseScale(1.0)
			self.itemArray[k]:setPosition(0, 0)
			self.itemArray[k]:setOwnScroll(self.scroll)
			self.itemArray[k]:setOwnView(self.view)
			self.itemArray[k]:addTo(self.Node_item)
		end
		self.itemArray[k]:setVisible(true)
		self.itemArray[k]:initData(v.id, v.count)
	end
	for i = #self.itemArray, #award + 1, -1 do
		if self.itemArray[i] then
			self.itemArray[i]:setVisible(false)
		end
	end
	local __, totalLen = SoraDToCenter(self.Node_item, 95, SoraDFIsRA())
	local scale = 1
	if 5 < #award then
		scale = 0.9
	end
	self.Node_item:setScale(scale)
	self.Node_item:setPosition(SoraDFPoint(513 - totalLen / 2 * scale + 10, 50, 536))
	self.type = otherData.type or 1
	if self.type == 3 then
		_ENV = SoraDFPoint(513 - totalLen / 2 * scale + 10, 50, 536)
		_ENV, _ENV, SoraDFPoint(513 - totalLen / 2 * scale + 10, 50, 536).num = data.num, string.formatnumberthousands(data.num) or 0, string.formatnumberthousands(data.num) or 0
		_ENV, (string.formatnumberthousands(data.num) or 0).num, data.num.color = data.num, data.num, "#FFFF00"
		;(string.formatnumberthousands(data.num) or 0).__default, data.num.color = data.num, "#AA9682"
		self.Text_des:setString(_G.i18n_html("god_beast_text_36", SoraDFPoint(513 - totalLen / 2 * scale + 10, 50, 536)))
	else
		local ctype = data.type or 1
		local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
		local atkTypeStr = wrathBeastCtrl:getAtkTypeStr(ctype)
		local BossName = i18n(worldMapDefine.getWorldBossName(data.bossType))
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).atkType = atkTypeStr
		_ENV, _ENV, worldMapDefine.getWorldBossName(data.bossType).BossName = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, worldMapDefine.getWorldBossName(data.bossType).atkType, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).__default, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType)[1] = _G.i18n_html("god_beast_text_32", worldMapDefine.getWorldBossName(data.bossType))
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).atkType = atkTypeStr
		_ENV, _ENV, worldMapDefine.getWorldBossName(data.bossType).BossName = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, worldMapDefine.getWorldBossName(data.bossType).atkType, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).__default, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType)[2] = _G.i18n_html("god_beast_text_33", worldMapDefine.getWorldBossName(data.bossType))
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).atkType = atkTypeStr
		_ENV, _ENV, worldMapDefine.getWorldBossName(data.bossType).num = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, (data.num or 0).atkType, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, (data.num or 0).num, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		;(data.num or 0).__default, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType)[3] = _G.i18n_html("god_beast_text_34", worldMapDefine.getWorldBossName(data.bossType))
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).atkType = atkTypeStr
		_ENV, _ENV, worldMapDefine.getWorldBossName(data.bossType).num = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, (data.num or 0).atkType, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, (data.num or 0).num, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		;(data.num or 0).__default, worldMapDefine.getWorldBossName(data.bossType).color = worldMapDefine.getWorldBossName(data.bossType)
		local worldMapDefine.getWorldBossName(data.bossType)[4], strConfig = _G.i18n_html("god_beast_text_35", worldMapDefine.getWorldBossName(data.bossType)), worldMapDefine.getWorldBossName(data.bossType)
		self.Text_des:setString(strConfig[ctype] or "")
	end
end
return wrathBeastAwardSingle
