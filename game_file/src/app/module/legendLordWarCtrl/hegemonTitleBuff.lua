local hegemonRead = include("hegemonRead")
local _ENV, hegemonTitleBuff = "hegemonRead", "hegemonRead"
function hegemonTitleBuff:initialize()
	if self.buff then
		return
	end
	self.buff, _ENV = self.buff, self.buff
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local allBuffList = hegemonRead.getAllBuffList()
	for title, buffs in pairs(allBuffList) do
		local _ENV, buffList
		for _, buffID in ipairs(buffs) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		self.buff[title] = buffList
	end
end
function hegemonTitleBuff:getTitleBuff(title, buffType)
	if title and buffType and self.buff then
		return self.buff[title] and self.buff[title][buffType]
	end
end
function hegemonTitleBuff:notifyBuffChange(title)
	if not title or not self.buff then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffList = self.buff[title]
	if buffList then
		for buffType, _ in pairs(buffList) do
			buffCtrl:dispatchBuffEvent(buffType, gBuffSource.HEGEMON_TITLE)
		end
	end
end
hegemonTitleBuff:initialize()
return hegemonTitleBuff
