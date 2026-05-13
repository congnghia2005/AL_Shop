from fastapi import FastAPI

app = FastAPI()  # Bắt buộc phải là tên "app" viết thường

@app.get("/")
def read_root():
    return {"Hello": "World"}