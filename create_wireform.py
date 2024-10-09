import base64
import dns.message

# Generate custom request
domain = "woodburn"

message = dns.message.make_query(domain, dns.rdatatype.A,id=0)

wireBytes = message.to_wire()
wire = base64.b64encode(wireBytes)
print(wire.decode("utf-8"))

# Read
message = dns.message.from_wire(wireBytes)
print(str(message))
