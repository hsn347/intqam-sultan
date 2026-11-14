local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_res = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_res", Com_WTV_res)
function Com_WTV_res:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.tableRes, _ENV = self.fixChildrenPos, self.fixChildrenPos
	_UPVALUE2_ = true
	self.tableRes[gIDDef.WOOD], (true)[1] = true, self.fields.Text_wood
	self.tableRes[gIDDef.WOOD], (true)[2] = true, self.fields.Image_1
	_UPVALUE2_ = true
	self.tableRes[gIDDef.FOOD], (true)[1] = true, self.fields.Text_food
	self.tableRes[gIDDef.FOOD], (true)[2] = true, self.fields.Image_2
	_UPVALUE2_ = true
	self.tableRes[gIDDef.IRON], (true)[1] = true, self.fields.Text_iron
	self.tableRes[gIDDef.IRON], (true)[2] = true, self.fields.Image_3
	_UPVALUE2_ = true
	self.tableRes[gIDDef.MITHRIL], (true)[1] = true, self.fields.Text_sliver
	self.tableRes[gIDDef.MITHRIL], (true)[2] = true, self.fields.Image_4
	_UPVALUE2_ = true
	self.tableRes[gIDDef.CRYSTAL], (true)[1] = true, self.fields.Text_crystal
	self.tableRes[gIDDef.CRYSTAL], (true)[2] = true, self.fields.Image_5
	for _, v in pairs(self.tableRes) do
		v[1]:setString("0")
	end
end
function Com_WTV_res:onShow()
end
function Com_WTV_res:initData(resourcesData, taxRate)
	local _ENV, resList
	if resourcesData and next(resourcesData) then
		for i, v in ipairs(resourcesData) do
			resList[v.id] = math.floor(v.num * (1 - taxRate / 1000))
		end
	else
		return
	end
	local index = 0
	local _ENV, visable = ipairs(resourcesData)
	for k, v in pairs(resList) do
		local lbimgs = self.tableRes[tonumber(k)]
		if tonumber(v) == -1 then
			lbimgs[1]:setString(i18n("common_text_601"))
		else
			lbimgs[1]:setString(self.nilOrHave(v))
		end
		lbimgs[1]:setVisible(true)
		lbimgs[2]:setVisible(true)
		index = index + 1
		table.insert(visable, lbimgs)
	end
	for i, v in ipairs(visable) do
		if SoraDFIsRA() then
			v[2]:setPosition(615 - (180 + i % 2 * 260), 60 * (math.ceil(i / 2) - 1) + 10)
		else
			v[2]:setPosition(100 + i % 2 * 260, 60 * (math.ceil(i / 2) - 1) + 10)
		end
	end
	for k, v in pairs(self.tableRes) do
		if tonumber(v[1]:getText()) == 0 then
			v[1]:setVisible(false)
			v[2]:setVisible(false)
		end
	end
	if 4 < index then
		self:setSize(cc.size(615, 200))
	elseif 3 <= index and index <= 4 then
		self:setSize(cc.size(615, 140))
	elseif index <= 2 then
		self:setSize(cc.size(615, 80))
	end
end
function Com_WTV_res.nilOrHave(val)
	if val then
		return string.formatnumberthousands(val)
	else
		return 0
	end
end
function Com_WTV_res:returnHeigh()
	return self:getSize().height
end
return Com_WTV_res
