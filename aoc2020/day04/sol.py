def input():
    data = {}
    for line in open("input"):
        line = line.strip()
        if len(line)==0:
            yield data
            data = {}
            continue
        for field, value in map(lambda x:tuple(x.split(":")), line.split(" ")):
            data[field]=value
    if len(data):
        yield data

reqed = set(['byr','iyr','eyr','hgt','hcl','ecl','pid'])

def validate_required(record):
    return len(reqed-set(record.keys())) == 0

def validate_number(value, min, max):
    if not str(int(value))==str(value):
        return False
    return min <= int(value) <= max
def validate_complex(record):
    return validate_required(record) \
        and validate_number(record["byr"], 1920, 2002) \
        and validate_number(record["iyr"], 2010, 2020) \
        and validate_number(record["eyr"], 2020, 2030) \
        and ( \
            record["hgt"][-2:]=="cm" and validate_number(record["hgt"][:-2], 150, 193) \
            or record["hgt"][-2:]=="in" and validate_number(record["hgt"][:-2], 59, 76)) \
        and record["ecl"] in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'] \
        and record["hcl"][0:1] == '#' \
        and len(set(record["hcl"][1:]) - set("0123456789abcdefABCDEF")) == 0 \
        and len(record["hcl"]) == 7 \
        and len(set(record["pid"]) - set("0123456789")) == 0 \
        and len(record["pid"]) == 9

    # if record["hgt"][0:2]=="cm":
    #     validate_number(record["hgt"][2:], 150, 193)
    # if record["hgt"][0:2]=="in":
    #     validate_number(record["hgt"][2:], 59, 76)


print(sum(map(validate_required, input())))

print(sum(map(validate_complex, input())))
