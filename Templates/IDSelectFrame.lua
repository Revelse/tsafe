
function CreateScrollFrame(parentClass,parentFrame,callback)
	local frame = CreateFrame("Frame",_,parentFrame)
	frame:SetSize(32,32)
	frame.m_Selected = 0
	frame.m_MaxScroll = 3
	frame.m_CallBack = callback
	frame.m_ParentClass = parentClass
	CreateButtonBorderTemplate(frame)
	local background = frame:CreateTexture("Background")
	background:SetTexture(0,0,0,0.3)
	background:SetAllPoints()
	local fontString = frame:CreateFontString(nil,"OVERLAY")
	fontString:SetFont("Fonts\\FRIZQT__.TTF", 11)
	fontString:SetPoint("CENTER",0,0)
	fontString:SetText(0)
	frame.m_FontString = fontString
	frame:SetScript("OnMouseWheel",
		function(widget,delta)
			local scrollKind = delta == -1 and "mouse_wheel_down" or "mouse_wheel_up"
				if scrollKind == "mouse_wheel_up" then
					if widget.m_Selected+1 <= widget.m_MaxScroll then
						widget.m_Selected = widget.m_Selected+1
					end
				else
					if widget.m_Selected-1 >= 0 then
						widget.m_Selected = widget.m_Selected-1
					end
				end
			widget.m_FontString:SetText(widget.m_Selected)
			widget.m_CallBack(widget.m_ParentClass,widget)
		end
	)

	return frame
end