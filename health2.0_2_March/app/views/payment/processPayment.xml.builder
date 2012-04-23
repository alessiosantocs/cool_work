xml.instruct!
xml.payment do
  
    xml.bCreditCard @pArray["bCreditCard"]
    xml.bSuccess @pArray["bSuccess"]
    xml.message @pArray["message"]
end

