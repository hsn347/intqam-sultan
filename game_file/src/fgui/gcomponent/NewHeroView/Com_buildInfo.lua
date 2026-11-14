local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
local buildRead = include("buildDescribeRead")
local cityltCtrl = include("cityltCtrl")
local buffDesRead = include("buffDesRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_buildInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_buildInfo", Com_buildInfo)
function Com_buildInfo:onInit()
	self:fixChildrenPos()
end
function Com_buildInfo:onShow()
end
function Com_buildInfo:initData(bid)
	self.bid = bid
	local buildIcon = string.format("icon_build_%d.png", self.bid)
	self.fields.icon_build:setSpriteFrame(buildIcon)
	self.fields.Text_buildName:setString(buildRead.getName(self.bid))
	local heroID = heroAppointCtrl:getAppointHero(self.bid)
	self.fields.Btn_hero:initData(self.bid, heroID)
	if heroID then
		local cfg = cityltCtrl.getBuildHeroAppointCfg(self.bid)
		local attrTb = heroltCtrl:getHeroAppointAttr(heroID)
		heroAppointCtrl = buildRead.getName(self.bid)
		buildRead.getName(self.bid)[1] = "buffType"
		buildRead.getName(self.bid)[2] = "buffValue"
		local buildAttrTb = serviceFunctions.tableFormat(cfg.attribute, buildRead.getName(self.bid))
		local _ENV, buildAttrStrTb = cfg.attribute, cfg.attribute
		for k, v in ipairs(buildAttrTb) do
			local value = v.buffValue * (1 + attrTb[cfg.direction] / 1000)
			local base, data = buffDesRead.getTitleBase(v.buffType, true)
			if data and data.effectType == 2 then
				value = math.floor(value)
			end
			local buffName = buffDesRead.getTitleWithValue(v.buffType)
			buffName = string.gsub(buffName, "<", "&lt;")
			local valStr = buffDesRead.getTitleValueWithValue(v.buffType, value)
			_ENV = buildRead.getName(self.bid)
			buildRead.getName(self.bid).name = buffName
			buildRead.getName(self.bid).num = fguiHelper.getColorString("#70C723", valStr)
			table.insert(buildAttrStrTb, i18n("%{name}:%{num}", buildRead.getName(self.bid)))
		end
		self.fields.Lab_attr:setString(table.concat(buildAttrStrTb, "\n"))
	else
		self.fields.Lab_attr:setString(i18n("hero_appoint_11"))
	end
end
function Com_buildInfo:getBtnHeroTouch()
	return self.fields.Btn_hero:getBtnTouch()
end
return Com_buildInfo
