# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app

# SỬA TẠI ĐÂY: Trỏ vào thư mục con để lấy package.json
COPY ./AL-shop-project/package*.json ./
RUN npm install

# SỬA TẠI ĐÂY: Copy toàn bộ thư mục code Angular vào
COPY ./AL-shop-project .

RUN npm run build -- --configuration=production

# Stage 2: Runtime
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
# Giữ nguyên đường dẫn dist vì lệnh build của Angular sẽ tạo ra folder này trong /app
COPY --from=build /app/dist/AL-shop-project/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]