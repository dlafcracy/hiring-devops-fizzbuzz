const request = require("supertest")
const baseURL = "http://localhost:3000"

process.env['HEALTHCHECK_TARGET_URL'] = baseURL
process.env['HEALTHCHECK_TARGET_INTERVAL'] = 2000

const server = require('./index')

describe("GET /", () => {
  it("should return 200 with empty json", async () => {
    const response = await request(baseURL).get("/");
    expect(response.statusCode).toBe(200);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toBe("{}");
  });
});

describe("GET /stubbed-process-1", () => {
  it("should return 200 with ok or 500 with not ok", async () => {
    const response = await request(baseURL).get("/stubbed-process-1");
    if (response.statusCode == 200) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("ok");
    } else if (response.statusCode == 500) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("not ok");
    }
  });
});

describe("GET /stubbed-process-2", () => {
  it("should return 200 with ok or 500 with not ok", async () => {
    const response = await request(baseURL).get("/stubbed-process-2");
    if (response.statusCode == 200) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("ok");
    } else if (response.statusCode == 500) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("not ok");
    }
  });
});

describe("GET /stubbed-process-3", () => {
  it("should return 200 with ok or 500 with not ok", async () => {
    const response = await request(baseURL).get("/stubbed-process-3");
    if (response.statusCode == 200) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("ok");
    } else if (response.statusCode == 500) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("not ok");
    }
  });
});

describe("GET /stubbed-process-4", () => {
  it("should return 200 with ok or 500 with not ok", async () => {
    const response = await request(baseURL).get("/stubbed-process-4");
    if (response.statusCode == 200) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("ok");
    } else if (response.statusCode == 500) {
      expect(response.body.error).toBe(undefined);
      expect(response.text).toBe("not ok");
    }
  });
});

describe("GET /stubbed-process-5", () => {
  it("should return 404 not found", async () => {
    const response = await request(baseURL).get("/stubbed-process-5");
    expect(response.statusCode).toBe(404);
    expect(response.body.error).toBe(undefined);
  });
});

describe("GET /load without prep", () => {
  it("should return 404", async () => {
    const response = await request(baseURL).get("/load/");
    expect(response.statusCode).toBe(404);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toBe("not found");
  });
});

describe("GET /load/dummydata without prep", () => {
  it("should return 404", async () => {
    const response = await request(baseURL).get("/load/dummydata");
    expect(response.statusCode).toBe(404);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toBe("not found");
  });
});

describe("POST /save with json dummydata", () => {
  const dummyData = {
    key: "dummydata"
  }
  it("should return 200 with an uuidv4", async () => {
    const response = await request(baseURL).post("/save").send(dummyData);
    expect(response.statusCode).toBe(200);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toMatch(/^[0-9A-F]{8}-[0-9A-F]{4}-[4][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i);
  });
});

describe("POST /save with empty post", () => {
  it("should return 200 with an uuidv4", async () => {
    const response = await request(baseURL).post("/save");
    expect(response.statusCode).toBe(200);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toMatch(/^[0-9A-F]{8}-[0-9A-F]{4}-[4][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i);
  });
});

describe("GET /load/dummydata2 with json dummydata2 prep", () => {
  const dummyData = {
    key: "dummydata2"
  }
  var prepResponse = "";
  beforeAll(async () => {
    prepResponse = await request(baseURL).post("/save").send(dummyData);
  })
  it("should return 200 and the dummydata", async () => {
    const response = await request(baseURL).get("/load/" + prepResponse.text);
    expect(response.statusCode).toBe(200);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toBe('{"key":"dummydata2"}');
  });
});

describe("GET /load/dummydata3 with text dummydata3 prep", () => {
  const dummyData = "dummydata3"
  var prepResponse = "";
  beforeAll(async () => {
    prepResponse = await request(baseURL).post("/save").send(dummyData);
  })
  it("should return 200 and the dummydata", async () => {
    const response = await request(baseURL).get("/load/" + prepResponse.text);
    expect(response.statusCode).toBe(200);
    expect(response.body.error).toBe(undefined);
    expect(response.text).toBe("dummydata3");
  });
});
